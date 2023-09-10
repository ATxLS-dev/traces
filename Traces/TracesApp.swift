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
    
    @StateObject var auth = AuthController()
    @StateObject var theme = ThemeController()

    var body: some Scene {
        WindowGroup {
            main
                .environmentObject(theme)
        }
    }
    
    @ViewBuilder
    var main: some View {
        ContentView()
            .implementPopupView()
    }
}

