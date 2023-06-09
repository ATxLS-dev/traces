//
//  TracesApp.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import PopupView
import Supabase

@main
struct TracesApp: App {
    
    @State var supabaseInitialized = false
    @StateObject var auth = AuthController()

    var body: some Scene {
        WindowGroup {
            main
        }
    }
    
    @ViewBuilder
    var main: some View {
        if supabaseInitialized {
            ContentView()
                .implementPopupView()
                .environmentObject(auth)
        } else {
            ProgressView()
                .task {
                    await supabase.auth.initialize()
                    supabaseInitialized = true
                }
        }
    }
}

let supabase = SupabaseClient(
    supabaseURL: Secrets.supabaseURL,
    supabaseKey: Secrets.supabaseAnonKey
    )

let auth = supabase.auth
