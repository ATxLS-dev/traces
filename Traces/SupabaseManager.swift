
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
    
    let supabase: SupabaseClient
    
    private var error: Error?
    private(set) var session: Session?
    private var categoriesSynced: Bool = false
    
    @Published private(set) var traces: [Trace] = []
    @Published private(set) var categories: [Category] = []
    @Published private(set) var filters: Set<String> = []
    @Published private(set) var filteredTraces: [Trace] = []
    @Published private(set) var userTraceHistory: [Trace] = []
    @Published var authChangeEvent: AuthChangeEvent?
    @Published var user: User?
    
    init() {
        supabase = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
        checkLogin()
    }
    
    private func loadTraces() async {
        let query = supabase.database.from("traces").select()
        do {
            error = nil
            traces = try await query.execute().value
        } catch {
            self.error = error
            print(error)
        }
    }
    private func syncCategories() async {

            let query = supabase.database.from("categories").select()
            do {
                error = nil
                categories = try await query.execute().value
                categoriesSynced = true
            } catch {
                self.error = error
                print(error)
            }
        
    }
    
    func reloadTraces() async {
        await loadTraces()
        if !categoriesSynced {
            await syncCategories()
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
    

}

// USER INTERACTION

extension SupabaseManager {
    
    func loadTracesFromUser() async {
        
        if let userID = self.user?.id {
            let query = supabase.database
                .from("traces")
                .select()
                .match(query: ["user_id": userID])
            checkLogin()
            do {
                userTraceHistory = try await query.execute().value
            } catch {
                self.error = error
                print(error)
            }
        }
    }
    
    private func clearUserTraceHistory() {
        userTraceHistory = []
        checkLogin()
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
    
}
    
// AUTH

extension SupabaseManager {
    
    private func checkLogin() {
        self.authChangeEvent = (user != nil) ? .signedIn : .signedOut
        Task {
            do {
                self.session = try await supabase.auth.session
                self.user = self.session?.user
                if user != nil {
                    self.authChangeEvent = .signedIn
                } else {
                    self.authChangeEvent = .signedOut
                }
            } catch {
                print(error)
            }
        }
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
            self.session = try await supabase.auth.session
            self.user = session?.user
            self.authChangeEvent = .signedIn
            await loadTracesFromUser()
        } catch {
            throw CreateUserError.signUpFailed(error.localizedDescription)
        }
    }
    
    func logout() async {
        do {
            try await supabase.auth.signOut()
            self.authChangeEvent = .signedOut
            self.user = nil
            clearUserTraceHistory()
        } catch {
            print(error)
        }
    }
}

private enum SupabaseError: Error {
    case dataNotFound
    case concurrentRequest
}
