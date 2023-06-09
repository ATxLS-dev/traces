//
//  ContentView.swift
//  GeoTag
//
//  Created by Bryce on 5/10/23.
//

import SwiftUI
import PopupView
import GoTrue
import MapKit
import Supabase
import CoreData

struct ContentView: View {

    @State var authEvent: AuthChangeEvent?
    @EnvironmentObject var auth: AuthController
    
    var body: some View {
        Group {
            if authEvent == .signedOut {
//                buildNavigation()
                buildAuthPopup()
            } else {
                buildNavigation()
            }
        }
//        .task {
//            for await event in supabase.auth.authEventChange {
//                withAnimation {
//                    authEvent = event
//                }
//                auth.session = try? await supabase.auth.session
//            }
//        }
    }
}

extension ContentView {
    func buildAuthPopup() -> some View {
        AuthPopup()
    }
}

extension ContentView {
    func buildNavigation() -> some View {
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
                    ProfileView()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

