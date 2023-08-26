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
    
    @State private var selectedTab: Tab = Tab.home
    @ObservedObject var locationController: LocationController = LocationController.shared
    @ObservedObject var authController: AuthController = AuthController.shared
    @ObservedObject var notificationController: NotificationController = NotificationController.shared
    @State var shouldPresentNotification: Bool = false
    
    var body: some View {
        buildNavigation()
            .onAppear {
                Task {
                    await locationController.checkLocationAuthorization()
                }
            }
        
    }

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
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            CustomTabBarView(currentTab: $selectedTab)
                .padding(.bottom, 28)
            NotificationView()
                .zIndex(1.0)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

