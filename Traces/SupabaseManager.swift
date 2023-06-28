
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

@MainActor
class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    let supabase: SupabaseClient = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
    let authManager = AuthManager.shared
    
    private var error: Error?
    
    private var isLoaded: Bool = false
    
    @Published private(set) var traces: [Trace] = []
    @Published private(set) var categories: [String] = []
    @Published private(set) var filters: Set<String> = []
    @Published private(set) var filteredTraces: [Trace] = []
    @Published private(set) var userTraceHistory: [Trace] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        authManager.$isSignedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSignedIn in
                if let userID = self?.authManager.userID {
                    self?.loadTracesFromUser(userID)
                } else {
                    self?.clearUserTraceHistory()  // Clear user-specific data
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadTraces() async {
        let query = supabase.database.from("traces").select()
        do {
            error = nil
            traces = try await query.execute().value //TEMP VALUES??
            var trimmedCategories = traces.map { $0.category }
            trimmedCategories = Array(Set(trimmedCategories))
            categories = trimmedCategories.sorted { $0 < $1 }
        } catch {
            self.error = error
            print(error)
        }
    }
    
    func reloadTraces() async {
        await loadTraces()
    }
    
    func loadTracesFromUser(_ userID: UUID) {
        let query = supabase.database
            .from("traces")
            .select()
            .match(query: ["user_id": userID])
        Task {
            userTraceHistory = try await query.execute().value
        }
//        do {
//            userTraceHistory = try await query.execute().value
//        } catch {
//            self.error = error
//            print(error)
//        }
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
        filters.contains(category) ? removeFilter(category: category) :
            addFilter(category: category)
        
        filterTraces()
    }
    
    func addFilter(category: String) {
        filters.insert(category)
    }
    
    func removeFilter(category: String) {
        filters.remove(category)
    }
    
    func filterTraces() {
        filteredTraces = traces.filter { filters.contains($0.category) }
    }
}

private enum SupabaseError: Error {
    case dataNotFound
    case concurrentRequest
}
