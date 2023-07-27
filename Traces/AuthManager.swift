//
//  AuthManager.swift
//  Traces
//
//  Created by Bryce on 7/27/23.
//

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
class AuthManager: ObservableObject {
    
    static let shared = AuthManager()
    let supabase: SupabaseClient = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
    
    private var error: Error?
    private(set) var session: Session?
    
    @Published private(set) var authChangeEvent: AuthChangeEvent?
    @Published private(set) var user: User?
    
    init() {
        checkAuthStatus()
    }
    
    private func checkAuthStatus() {
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
    
    func login(email: String, password: String) async throws {
        do {
            try await supabase.auth.signIn(email: email, password: password)
            self.session = try await supabase.auth.session
            self.user = session?.user
            self.authChangeEvent = .signedIn
        } catch {
            throw CreateUserError.signUpFailed(error.localizedDescription)
        }
    }
    
    func logout() async {
        do {
            try await supabase.auth.signOut()
            self.authChangeEvent = .signedOut
            self.user = nil
        } catch {
            print(error)
        }
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
        }
    }


    
    func createNewUser(email: String, password: String) async throws {
        do {
            try await supabase.auth.signUp(email: email, password: password)
        } catch {
            throw CreateUserError.signUpFailed(error.localizedDescription)
        }
    }
    
    func setUsername(_ username: String) {
        
        let updateData: [String: String] = ["username" : username]
        
        let query = supabase.database.from("users")
            .update(values: updateData)
            .eq(column: "id", value: user!.id)
        
        //ALSO SET UPDATE DATE TO DATE CHANGED
        
        Task {
            do {
                try await query.execute()
            } catch {
                print(error)
            }
        }
    }
    

    
    func deleteAccount() {
        
        if authChangeEvent == .signedOut { return }
        
        let userID = self.user!.id
        let query = supabase.database.from("users")
            .delete()
            .eq(column: "id", value: userID)
        
        Task {
            do {
                try await query.execute()
                await logout()
            } catch {
                print(error)
            }
        }
    }
}
