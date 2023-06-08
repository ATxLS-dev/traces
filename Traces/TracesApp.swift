//
//  TracesApp.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import PopupView

@main
struct TracesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .implementPopupView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
