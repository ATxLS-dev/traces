
//
//  Supabaseinator.swift
//  Traces
//
//  Created by Bryce on 6/8/23.


import Foundation
import Supabase
import SwiftUI

let supabase = SupabaseClient(
    supabaseURL: Secrets.supabaseURL,
    supabaseKey: Secrets.supabaseAnonKey
)

let auth = supabase.auth

class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    let supabase: SupabaseClient
    private var error: Error?
    
    private var isLoaded: Bool = false
    
    @Published private(set) var traces: [Trace] = []
    @Published private(set) var categories: [String] = []
    @Published private(set) var filters: Set<String> = []
    @Published private(set) var filteredTraces: [Trace] = []
    
    private init() {
        supabase = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
        if isLoaded {
            Task {
                await loadTraces()
            }
        }
    }
    
    private func loadTraces() async {
        let query = supabase.database.from("traces").select()
        do {
            error = nil
            traces = try await query.execute().value
            categories = traces.map { $0.category }
            categories = Array(Set(categories))
            categories = categories.sorted { $0 < $1 }
        } catch {
            self.error = error
            print(error)
        }
    }
    
    func reloadTraces() async {
            await loadTraces()
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
