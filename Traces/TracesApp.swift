//
//  TracesApp.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI

@main
struct TracesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
