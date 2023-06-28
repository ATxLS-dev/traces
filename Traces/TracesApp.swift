//
//  TracesApp.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import PopupView
import Supabase
import GoTrue

@main
struct TracesApp: App {
    
    @State var authEvent: AuthChangeEvent?
    @State var supabaseInitialized = false
    @StateObject var auth = AuthController()
    @ObservedObject var authManager = AuthManager.shared

    var body: some Scene {
        WindowGroup {
            main
        }
    }
    
    @ViewBuilder
    var main: some View {
        if authManager.authChangeEvent == .signedIn {
            ContentView()
                .implementPopupView()
                .environmentObject(auth)
        } else {
            SettingsView()
//            ProgressView()
//                .task {
//                    await supabase.auth.initialize()
//                    supabaseInitialized = true
//                }
        }
//        if supabaseInitialized {
//            ContentView()
//                .implementPopupView()
//                .environmentObject(auth)
//        } else {
//            ProgressView()
//                .task {
//                    await supabase.auth.initialize()
//                    supabaseInitialized = true
//                }
//        }
    }
}

