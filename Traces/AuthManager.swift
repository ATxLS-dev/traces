
//
//  Supabaseinator.swift
//  Traces
//
//  Created by Bryce on 6/8/23.

import Foundation
import Supabase
import SwiftUI
import MapboxStatic
import GoTrue

enum CreateUserError: Error {
    case signUpFailed(String)
}

@MainActor
class AuthManager: ObservableObject {
    
    static let shared = AuthManager()
    
    @Published var session: Session?
    @Published var authChangeEvent: AuthChangeEvent?
    @Published var isSignedIn: Bool = false
    @Published var userID: UUID?
    
    let supabase: SupabaseClient = SupabaseClient(
        supabaseURL: Secrets.supabaseURL,
        supabaseKey: Secrets.supabaseAnonKey
    )

    private init() {
        Task {
            do {
                self.session = try await supabase.auth.session
                self.authChangeEvent = .signedOut
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
    
    func login(email: String, password: String) async {
        do {
            try await supabase.auth.signIn(email: email, password: password)
            await handleLoginSuccess()
        } catch {
            print(error)
        }
    }
    
    func logout() async {
        do {
            try await supabase.auth.signOut()
            await handleLogoutSuccess()
        } catch {
            print(error)
        }
    }
    
    private func handleLoginSuccess() async {
        self.authChangeEvent = .signedIn
        self.isSignedIn = true
        self.userID = session?.user.id
    }
    
    private func handleLogoutSuccess() async {
        self.authChangeEvent = .signedOut
        self.isSignedIn = false
        
        self.userID = nil
    }
}

private enum SupabaseError: Error {
    case dataNotFound
    case concurrentRequest
}


//
//import Foundation
//import Supabase
//import SwiftUI
//import MapboxStatic
//import GoTrue
//
//enum CreateUserError: Error {
//    case signUpFailed(String)
//}
//
//@MainActor
//class AuthManager: ObservableObject {
//
//    static let shared = AuthManager()
//
//    @Published var session: Session?
//    @Published var authChangeEvent: AuthChangeEvent?
//
//    private let supabase: SupabaseClient = SupabaseClient(
//            supabaseURL: Secrets.supabaseURL,
//            supabaseKey: Secrets.supabaseAnonKey
//        )
//
//    private var isLoggedIn: Bool = false
//
//    private init(){
//        Task {
//            self.session = try await supabase.auth.session
//            self.authChangeEvent = .signedOut
//        }
//    }
//
//    func createNewUser(email: String, password: String) async throws {
//        do {
//            try await supabase.auth.signUp(email: email, password: password)
//        } catch {
//            throw CreateUserError.signUpFailed(error.localizedDescription)
//        }
//    }
//
//    func login(email: String, password: String) async {
//        do {
//            try await supabase.auth.signIn(email: email, password: password)
//            authChangeEvent = .signedIn
//        } catch {
//            print(error)
//        }
//    }
//
//    func logout() async {
//        do {
//            try await supabase.auth.signOut()
//            authChangeEvent = .signedOut
//        } catch {
//            print(error)
//        }
//
//    }
//}
//
//private enum SupabaseError: Error {
//    case dataNotFound
//    case concurrentRequest
//}
