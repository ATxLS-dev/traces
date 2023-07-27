
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


@MainActor
class SupabaseManager: ObservableObject {
    
    static let shared = SupabaseManager()
    let supabase: SupabaseClient = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
    @ObservedObject var auth = AuthManager.shared
    
    private var error: Error?
    
    @Published private(set) var traces: [Trace] = []
    @Published private(set) var filteredTraces: [Trace] = []
    
    @Published private(set) var categories: [Category] = []
    @Published private(set) var filters: Set<String> = []
    
    init() {
        syncCategories()
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
        filteredTraces = traces.filter { filters.contains($0.categories) }
    }
    
    func convertFromTimestamptzDate(_ rawDate: String) -> Date {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: rawDate) {
            return date
        }
        return Date()
    }

    func loadTracesFromUser(_ id: UUID? = nil) async -> [Trace] {
        
        var userTraceHistory: [Trace] = []
        
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
        return userTraceHistory
    }
    
    private func parseJSON(_ json: String) -> String {
        
        guard let jsonData = json.data(using: .utf8) else {
            return "Invalid JSON string"
        }
        
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]],
               let username = jsonArray.first?["username"] as? String {
                return username
            } else {
                print("JSON format invalid")
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
        return "Username not set"
    }
    
    func getUsernameFromID(_ id: UUID) async -> String {
        
        let query = supabase.database
            .from("users")
            .select(columns: "username")
            .eq(column: "id", value: id)
        var result: String = ""
        do {
            result = try await query.execute().value
        } catch {
            self.error = error
            print(error)
        }
        return parseJSON(result)
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
}
