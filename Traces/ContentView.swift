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
    @ObservedObject var locationManager: LocationManager = LocationManager.shared
    @ObservedObject var authManager: AuthManager = AuthManager.shared
    @ObservedObject var notificationManager: NotificationManager = NotificationManager.shared
    @State var shouldPresentNotification: Bool = false
    
    var body: some View {
        buildNavigation()
            .onAppear {
                Task {
                    await locationManager.checkLocationAuthorization()
                }
            }
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
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            CustomTabBarView(currentTab: $selectedTab)
                .padding(.bottom, 28)
        }
        .onTapGesture {
            shouldPresentNotification = notificationManager.shouldPresent
        }
        .ignoresSafeArea()
        .overlay {
            NotificationView(notification: notificationManager.notification ?? .signedIn, isPresented: $shouldPresentNotification)
                .transition(.move(edge: self.shouldPresentNotification ? .trailing : .leading))
                .animation(
                    .interactiveSpring(response: 0.3, dampingFraction: 0.69, blendDuration: 0.69), value: self.shouldPresentNotification)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

