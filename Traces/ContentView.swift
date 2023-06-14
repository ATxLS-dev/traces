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

struct ContentView: View {
    
    init() {
        UIToolbar.changeAppearance(clear: true)
    }
    
    @State private var selectedTab: Tab = Tab.home

    @State var authEvent: AuthChangeEvent?
    @EnvironmentObject var auth: AuthController
    
    var body: some View {
        Group {
            if authEvent == .signedOut {
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
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(Tab.home)
                MapPageView()
                    .tag(Tab.map)
                ProfileView()
                    .tag(Tab.profile)
                SettingsView()
                    .tag(Tab.settings)
            }
            .tabViewStyle(PageTabViewStyle())
            CustomTabBarView(currentTab: $selectedTab)
                .padding(.bottom)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

