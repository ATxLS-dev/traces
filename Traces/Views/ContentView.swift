//
//  ContentView.swift
//  Traces
//
//  Created by Bryce on 5/10/23.
//

import SwiftUI
import PopupView
import GoTrue
import MapKit
import Supabase

struct ContentView: View {
    
    @StateObject var theme = ThemeController()
    @StateObject var notifications = NotificationController()
    @StateObject var auth = AuthController()
    @StateObject var locator = LocationController()
    @StateObject var supabase = SupabaseController()
    @StateObject var feed = FeedController()
    @StateObject var sheet = SheetController()
    
    @AppStorage("selectedTab") private var selectedTab: Tab = Tab.home
    
    @State var shouldPresentOnboardingSheet: Bool = false
    
    init() {
        shouldPresentOnboardingSheet = UserDefaults.hasOnboarded
    }
    
    var body: some View {
        buildNavigation()
            .fullScreenCover(isPresented: $shouldPresentOnboardingSheet) {
                Onboarding(isPresented: $shouldPresentOnboardingSheet)
            }
            .onAppear {
                Task {
                    await locator.checkLocationAuthorization()
                }
            }
            .environmentObject(theme)
            .environmentObject(notifications)
            .environmentObject(auth)
            .environmentObject(locator)
            .environmentObject(supabase)
            .environmentObject(feed)
            .environmentObject(sheet)
        
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
        ZStack {
            ContentView()
                .environmentObject(ThemeController())
                .environmentObject(NotificationController())
                .environmentObject(AuthController())
                .environmentObject(LocationController())
                .environmentObject(SupabaseController())
                .environmentObject(FeedController())
                .environmentObject(SheetController())
        }
    }
}

