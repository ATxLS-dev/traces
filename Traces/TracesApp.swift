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
    
    

    var body: some Scene {
        WindowGroup {
            main
        }
    }
    
    @ViewBuilder
    var main: some View {
        ContentView()
            .implementPopupView()
    }
}

