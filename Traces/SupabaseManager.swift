
//
//  Supabaseinator.swift
//  Traces
//
//  Created by Bryce on 6/8/23.


import Foundation
import Supabase
import SwiftUI
import MapboxStatic
import Combine
import GoTrue

enum CreateUserError: Error {
    case signUpFailed(String)
}

@MainActor
class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    let supabase: SupabaseClient = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
    
    private var error: Error?
    
    private var isLoaded: Bool = false
    
    @Published private(set) var traces: [Trace] = []
    @Published private(set) var categories: [String] = []
    @Published private(set) var filters: Set<String> = []
    @Published private(set) var filteredTraces: [Trace] = []
    @Published private(set) var userTraceHistory: [Trace] = []
    @Published var session: Session?
    @Published var authChangeEvent: AuthChangeEvent?
//    @Published var isSignedIn: Bool = false
    @Published var userID: UUID?
    @Published var user: User?

    
//    private var cancellables = Set<AnyCancellable>()
    
    init() {
        checkLogin()

    }
    
    private func checkLogin() {
        Task {
            do {
                self.session = try await supabase.auth.session
                self.user = self.session?.user
            } catch {
                print(error)
            }
        }
//        authManager.$authChangeEvent
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] event in
//                guard event == .signedIn, let userID = self?.authManager.userID else {
//                    self?.clearUserTraceHistory()
//                    return
//                }
//                Task {
//                    await self?.loadTracesFromUser(userID)
//                }
//            }
//            .store(in: &cancellables)
        
    }

    
    private func loadTraces() async {
        let query = supabase.database.from("traces").select()
        do {
            error = nil
            traces = try await query.execute().value
            categories = Array(Set(traces.map { $0.category })).sorted { $0 < $1 }
        } catch {
            self.error = error
            print(error)
        }
    }
    
    func reloadTraces() async {
        await loadTraces()
    }
    
    func loadTracesFromUser(_ userID: UUID) async {
        let query = supabase.database
            .from("traces")
            .select()
            .match(query: ["user_id": userID])
        
        checkLogin()
        
        if self.authChangeEvent == .signedIn {
            do {
                userTraceHistory = try await query.execute().value
            } catch {
                self.error = error
                print(error)
            }
        } else {
            print("not signed in")
        }
    }
    
    func clearUserTraceHistory() {
        userTraceHistory = []
    }
    
    func addTrace(trace: Trace) async {
        let query = supabase.database
            .from("traces")
            .insert(values: trace)
        do {
            try await query.execute()
        } catch {
            self.error = error
            print(error)
        }
    }
    
    func toggleFilter(category: String) {
        if filters.contains(category) {
            filters.remove(category)
        } else {
            filters.insert(category)
        }
        filteredTraces = traces.filter { filters.contains($0.category) }
    }

    func createNewUser(email: String, password: String) async throws {
        do {
            try await supabase.auth.signUp(email: email, password: password)
        } catch {
            throw CreateUserError.signUpFailed(error.localizedDescription)
        }
    }
    
    func login(email: String, password: String) async throws {
        do {
            try await supabase.auth.signIn(email: email, password: password)
            self.authChangeEvent = .signedIn
            self.userID = session?.user.id
        } catch {
            throw CreateUserError.signUpFailed(error.localizedDescription)
        }
    }
    
    func logout() async {
        do {
            try await supabase.auth.signOut()
            self.authChangeEvent = .signedOut
            self.userID = nil
        } catch {
            print(error)
        }
    }
}

private enum SupabaseError: Error {
    case dataNotFound
    case concurrentRequest
}
