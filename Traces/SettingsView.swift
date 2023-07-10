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
    
    @State var authEvent: AuthChangeEvent?
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var supabase = SupabaseManager.shared
    @State var shouldPresentAuthSheet: Bool = false
    @State var shouldPresentAccountSheet: Bool = false
    
    var body: some View {
        ZStack {
            Spacer()
                .background(themeManager.theme.background)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                buildListItem(item: buildLabel(title: "Manage Account", systemImage: "person"))
                    .onTapGesture {
                        Task {
                            if supabase.authChangeEvent == .signedIn {
                                shouldPresentAccountSheet.toggle()
                            }
                        }
                    }
                    .sheet(isPresented: $shouldPresentAccountSheet) {
                        AccountView(isPresented: $shouldPresentAccountSheet)
                    }
                buildListItem(item: buildLabel(title: "FAQ", systemImage: "questionmark"))
                buildListItem(item: buildLabel(title: "Notifications", systemImage: "bell"))
                buildListItem(item: themeManager.isDarkMode ?
                              buildLabel(title: "Dark Mode", systemImage: "moon")
                              : buildLabel(title: "Light Mode", systemImage: "sun.max"))
                    .onTapGesture {
                        themeManager.toggleTheme()
                    }
                buildListItem(item: buildLabel(title: supabase.authChangeEvent == .signedIn ? "Log Out" : "Log in / Sign up", systemImage: "hand.wave"))
                    .onTapGesture {
                        Task {
                            if supabase.authChangeEvent == .signedIn {
                                await supabase.logout()
                            } else {
                                shouldPresentAuthSheet.toggle()
                            }
                        }
                    }
                    .sheet(isPresented: $shouldPresentAuthSheet) {
                        AuthView(isPresented: $shouldPresentAuthSheet)
//                            .frame(width: 300, height: 400)
//                            .clearModalBackground()
                    }
                Spacer()
                
            }
            .padding(.top, 69)
        }
        .foregroundColor(themeManager.theme.text)
    }
}

extension SettingsView {
    
    func buildLabel(title: String, systemImage: String) -> some View {
        Label {
            Text(title)
                .padding(.horizontal, 6)
                .padding(.vertical, 16)
        } icon: {
            Circle()
                .fill(themeManager.theme.button)
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: systemImage)
                    .foregroundColor(themeManager.theme.text)
                )
        }
    }
    
    func buildListItem(item: some View) -> some View {
        HStack {
            item
            Spacer()
        }
        .padding(.horizontal, 10)
        .background(
            capsuleBackground()
        )
        .padding(.horizontal)
    }
    
    func capsuleBackground() -> some View {
        ZStack {
            Capsule().fill(themeManager.theme.backgroundAccent)
            Capsule().stroke(themeManager.theme.border, lineWidth: 2)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
