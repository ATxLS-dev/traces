//
//  SettingsView.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import Foundation
import GoTrue

struct SettingsView: View {
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var supabase: SupabaseController

    @State var shouldPresentAuthSheet: Bool = false
    @State var shouldPresentAccountSheet: Bool = false
    @State var shouldPresentFAQSheet: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                buildListItem(item: buildLabel(title: "Manage Account", systemImage: "person"))
                    .opacity(auth.authChangeEvent == .signedIn ? 1 : 0.6)
                    .onTapGesture {
                        Task {
                            if auth.authChangeEvent == .signedIn {
                                shouldPresentAccountSheet.toggle()
                            }
                        }
                    }
                    .sheet(isPresented: $shouldPresentAccountSheet) {
                        AccountDetailView()
                    }
                buildListItem(item: buildLabel(title: "FAQ", systemImage: "questionmark"))
                    .onTapGesture { shouldPresentFAQSheet.toggle() }
                    .sheet(isPresented: $shouldPresentFAQSheet) {
                        FAQSheet()
                    }
                buildListItem(item: theme.isDarkMode ?
                              buildLabel(title: "Dark Mode", systemImage: "moon")
                              : buildLabel(title: "Light Mode", systemImage: "sun.max"))
                    .onTapGesture { 
                        theme.toggleTheme()
                    }
                buildListItem(item: buildLabel(title: auth.authChangeEvent == .signedIn ? "Log Out" : "Log in / Sign up", systemImage: "hand.wave"))
                    .onTapGesture {
                        if auth.authChangeEvent == .signedIn {
                            auth.logout()
                        } else {
                            shouldPresentAuthSheet.toggle()
                        }
                    }
                    .sheet(isPresented: $shouldPresentAuthSheet) {
                        AuthView()
                    }
                Spacer()
                
            }
            .padding(.top, 69)
        }
        .foregroundColor(theme.text)
        .background(theme.background)
    }
}

extension SettingsView {
    
    func buildLabel(title: String, systemImage: String) -> some View {
        Label {
            Text(title)
                .padding(.horizontal, 6)
                .padding(.vertical, 16)
        } icon: {
            ZStack {
                Circle()
                    .fill(theme.buttonBackground)
                Circle()
                    .stroke(theme.buttonBorder, lineWidth: 1.4)
            }
            .frame(width: 36, height: 36)
            .overlay(
                Image(systemName: systemImage)
            )
            .foregroundColor(theme.text)
        }
    }
    
    func buildListItem(item: some View) -> some View {
        HStack {
            item
            Spacer()
        }
        .padding(.horizontal, 10)
        .background( BorderedCapsule() )
        .padding(.horizontal)
    }
}
