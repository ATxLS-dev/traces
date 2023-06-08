//
//  ContentView.swift
//  GeoTag
//
//  Created by Bryce on 5/10/23.
//

import SwiftUI
import MapKit
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trace.datePosted, ascending: true)],
        animation: .default)
    private var traces: FetchedResults<Trace>
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .foregroundColor(snow)
                    .edgesIgnoringSafeArea(.all)
                TabView() {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    MapView()
                        .tabItem {
                            Image(systemName: "map")
                            Text("Map")
                        }
                    Spacer()//NEEDS TO NOT BE CLICKABLE
                    ListView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("My Profile")
                        }
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                }

                .accentColor(sweetGreen)
                NewTraceButton()
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { traces[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

