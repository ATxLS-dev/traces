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
class AuthController: ObservableObject {
    
    static var shared = AuthController()
    
    let supabase: SupabaseClient = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
    
    private var error: Error?
    @Published private(set) var session: Session?
    @Published private(set) var authChangeEvent: AuthChangeEvent?
    
    init() {
        startSession()
    }
    
    private func startSession() {
        Task {
            do {
                self.session = try await supabase.auth.session
                self.authChangeEvent = (session != nil) ? .signedIn : .signedOut
            } catch {
                print(error)
            }
        }
    }
    
    func login(email: String, password: String) async throws {
        do {
            try await supabase.auth.signIn(email: email, password: password)
            self.session = try await supabase.auth.session
            self.authChangeEvent = .signedIn
        } catch {
            throw CreateUserError.signUpFailed(error.localizedDescription)
        }
    }
    
    func logout() {
        if authChangeEvent == .signedOut { return }
        Task {
            do {
                try await supabase.auth.signOut()
                self.authChangeEvent = .signedOut
                self.session = nil
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
    
    func getCurrentUsername() async -> String {
        if authChangeEvent == .signedOut { return "" }
        
        let query = supabase.database.from("users")
            .select(columns: "username")
            .eq(column: "id", value: session!.user.id)
        
        var result: String = ""

        do {
            result = try await query.execute().value
        } catch {
            print(error)
        }
        return parseJSON(result)
        
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
    
    func setUsername(_ username: String) {
        
        if authChangeEvent == .signedOut { return }
        
        let updateData: [String: String] = ["username" : username]
        
        let query = supabase.database.from("users")
            .update(values: updateData)
            .eq(column: "id", value: session!.user.id)
        
        //ALSO SET UPDATE DATE TO DATE CHANGED
        
        Task {
            do {
                try await query.execute()
            } catch {
                print(error)
            }
        }
    }
    
    func setBio(_ bio: String) {
        if authChangeEvent == .signedOut { return }
        
        let updateData: [String: String] = ["bio": bio]
        
        let query = supabase.database.from("users")
            .update(values: updateData)
            .eq(column: "id", value: session!.user.id)
        
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
        
        let userID = session!.user.id
        let query = supabase.database.from("users")
            .delete()
            .eq(column: "id", value: userID)
        
        Task {
            do {
                logout()
                try await query.execute()
            } catch {
                print(error)
            }
        }
    }
}
