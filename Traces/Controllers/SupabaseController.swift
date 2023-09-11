
//
//  Supabaseinator.swift
//  Traces
//
//  Created by Bryce on 6/8/23.


import Foundation
import Supabase
import SwiftUI
import MapKit
import MapboxStatic
import Combine
import GoTrue
import CoreLocation

@MainActor
class SupabaseController: ObservableObject {
    
    let supabase: SupabaseClient = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var locator: LocationController
    
    private var error: Error?
    
    @Published private(set) var traces: [Trace] = []
    @Published private(set) var filteredTraces: [Trace] = []
    
    @Published private(set) var categories: [Category] = []
    @Published private(set) var filters: Set<String> = []
    
    @Published private(set) var reactionTypes: [ReactionType] = []
    
    @Published private(set) var userTraceHistory: [Trace] = []
    @Published var feed: [Trace] = []
    
    private var feedMaxDistanceInMiles: Int = 15
    
    init() {
        syncCategories()
        syncReactionTypes()
    }
    
    private func syncCategories() {
        let query = supabase.database.from("categories").select()
        Task {
            do {
                error = nil
                categories = try await query.execute().value
            } catch {
                self.error = error
                print(error)
            }
        }
    }
    
    private func syncReactionTypes() {
        let query = supabase.database.from("reaction_types").select()
        Task {
            do {
                error = nil
                reactionTypes = try await query.execute().value
            } catch {
                self.error = error
                print(error)
            }
        }
    }
    
    func countCategoryOccurences(_ category: Category) -> Int {
        let occurrences = traces
            .flatMap { $0.categories }
            .filter { $0 == category.name }
            .count
        return occurrences
    }
    
    func reloadTraces() async {
        let query = supabase.database.from("traces").select()
        do {
            error = nil
            traces = try await query.execute().value
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
        if filters == [] {
            filteredTraces = []
        } else {
            filteredTraces = traces.filter { trace in
                let commonCategories = Set(trace.categories).intersection(Set(filters))
                return !commonCategories.isEmpty
            }
        }
    }

    func loadTracesFromUser(_ id: UUID? = nil) async {
        if let userID = id ?? auth.session?.user.id {
            let query = supabase.database
                .from("traces")
                .select()
                .match(query: ["user_id": userID])
            do {
                userTraceHistory = try await query.execute().value
                error = nil
            } catch {
                self.error = error
                print(error)
            }
        }
    }
    
    func getFromID(_ id: UUID, column data: String) async -> String {
        
        let query = supabase.database
            .from("users")
            .select(columns: data)
            .eq(column: "id", value: id)
        
        var result: String = ""
        
        do {
            result = try await query.execute().value
        } catch {
            self.error = error
            print(error)
        }
        
        return result.parseData(data)
        
    }
    
    func createNewTrace(locationName: String, content: String, categories: [String], location: CLLocationCoordinate2D) {
        if auth.authChangeEvent == .signedIn {
            let date = Date()
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            let creationDateInTimestamptz = formatter.string(from: date)
       
            let newTrace: Trace = Trace(
                id: UUID(),
                userID: auth.session!.user.id,
                creationDate: creationDateInTimestamptz,
                latitude: location.latitude,
                longitude: location.longitude,
                locationName: locationName,
                content: content,
                categories: categories
            )
            let query = supabase.database
                .from("traces")
                .insert(values: newTrace)
            Task {
                do {
                    try await query.execute()
                } catch {
                    self.error = error
                    print("Error inserting trace: \(error)")
                }
            }
        } else {
            print("Cannot create trace without signing in")
        }
    }
    
    func updateTrace(_ newTrace: Trace) {
        let query = supabase.database
            .from("traces")
            .update(values: newTrace)
            .eq(column: "trace_id", value: newTrace.id)
        Task {
            do {
                try await query.execute()
                await self.loadTracesFromUser(newTrace.userID)
            } catch {
                self.error = error
                print("Error editing trace: \(error)")
            }
        }
    }
    
    func deleteTrace(_ trace: Trace) {
        let query = supabase.database
            .from("traces")
            .delete()
            .eq(column: "trace_id", value: trace.id)
        Task {
            do {
                try await query.execute()
                await self.loadTracesFromUser(trace.userID)
            } catch {
                self.error = error
                print("Error editing trace: \(error)")
            }
        }
    }
}
