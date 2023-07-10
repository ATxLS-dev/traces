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
    
    @ObservedObject var supabaseManager = SupabaseManager.shared

    var body: some Scene {
        WindowGroup {
            main
        }
    }
    
    @ViewBuilder
    var main: some View {
        if supabaseManager.authChangeEvent == .signedIn {
            ContentView()
                .implementPopupView()
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

