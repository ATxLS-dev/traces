
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
    let auth = AuthController.shared
    let locator = LocationController()
    
    @Published private(set) var traces: [Trace] = []
    @Published private(set) var categories: [Category] = []
    @Published private(set) var reactionTypes: [ReactionType] = []
    @Published private(set) var userTraceHistory: [Trace] = []
    
    private var feedMaxDistanceInMiles: Int = 15
    
    init() {
        syncCategories()
        syncReactionTypes()
    }
    
    private func syncCategories() {
        let query = supabase.database.from("categories").select()
        Task {
            do {
                categories = try await query.execute().value
            } catch {
                print(error)
            }
        }
    }
    
    private func syncReactionTypes() {
        let query = supabase.database.from("reaction_types").select()
        Task {
            do {
                reactionTypes = try await query.execute().value
            } catch {
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
            traces = try await query.execute().value
        } catch {
            print(error)
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
            } catch {
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
                print("Error updating trace: \(error)")
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
                print("Error deleting trace: \(error)")
            }
        }
    }
    
    func getReactions(to traceID: UUID) async -> [(String, Int)] {
        
        var result: [Reaction] = []
        let query = supabase.database
            .from("reactions")
            .select()
            .eq(column: "trace_id", value: traceID)
        
        do {
            result = try await query.execute().value
        } catch {
            print("Error fetching reactions: \(error)")
        }
        
        var reactionRawTypes: [UUID: String] = [:]
        reactionTypes.forEach { item in
            reactionRawTypes[item.id] = item.value
        }
        
        let reactions: [UUID] = result.map(\.reactionType)
        let end = Dictionary(grouping: reactions) { $0 }
            .map { (reactionRawTypes[$0]!, $1.count) }
        
        return end
    }
    
    func createReaction(to traceID: UUID, reactionType: String) async throws {
        print("create reaction called")
        
        guard auth.authChangeEvent != .signedOut, let session = auth.session else {
            throw ReactionError.signedOut
        }
        
        let date = Date()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        let creationDateInTimestamptz = formatter.string(from: date)
        
        
        guard let reactionTypeID = reactionTypes
            .first(where: { $0.value == reactionType })?.id else {
            throw ReactionError.reactionTypeNotFound
        }
        
        let newReaction = Reaction(
            id: UUID(),
            traceID: traceID,
            userID: session.user.id,
            creationDate: creationDateInTimestamptz,
            reactionType: reactionTypeID)
        print(newReaction)
        
        let query = supabase.database
            .from("reactions")
            .insert(values: newReaction)
        
        do {
            try await query.execute()
        } catch {
            throw ReactionError.databaseError
        }
    }
    
    
    func updateReaction() {
        
    }
    
    func deleteReaction() {
        
    }
}
