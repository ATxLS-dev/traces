
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
    @Published private(set) var filteredTraces: [Trace] = []
    @Published private(set) var categories: [Category] = []
    @Published private(set) var filters: Set<String> = []
    @Published private(set) var userTraceHistory: [Trace] = []
    @Published private(set) var authChangeEvent: AuthChangeEvent?
    @Published private(set) var user: User?
    
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
        filteredTraces = traces.filter { filters.contains($0.categories) }
    }
    
    func convertFromTimestamptzDate(_ rawDate: String) -> Date {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: rawDate) {
            return date
        }
        return Date()
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
    
    private func parseJSON(_ json: String) -> String {
        let jsonString = json

        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Invalid JSON string")
            return ""
        }
        
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]],
               let email = jsonArray.first?["email"] as? String {
                return email
            } else {
                print("Invalid JSON format")
            }
        } catch {
            print("Error parsing JSON: \(error)")

        }
        return ""
    }
    
    func getUsernameFromID(_ id: UUID) async -> String {

        //CHANGE TO USERNAME LATER
        let query = supabase.database
            .from("users")
            .select(columns: "email")
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
        if authChangeEvent == .signedIn {
            let date = Date()
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            let creationDateInTimestamptz = formatter.string(from: date)
            
            let newTrace: Trace = Trace(
                id: UUID(),
                userID: user!.id,
                creationDate: creationDateInTimestamptz,
                latitude: location.latitude,
                longitude: location.longitude,
                locationName: locationName,
                content: content,
                categories: categories
            )
            addTrace(trace: newTrace)
        }
    }
    
    private func addTrace(trace: Trace) {
        let query = supabase.database
            .from("traces")
            .insert(values: trace)
        Task {
            do {
                print(trace)
                try await query.execute()
            } catch {
                self.error = error
                print("Error inserting trace: \(error)")
            }
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
