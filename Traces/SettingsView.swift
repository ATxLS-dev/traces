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
    @ObservedObject var supabaseManager = SupabaseManager.shared
    @State var shouldPresentSheet: Bool = false
    
    var body: some View {
        ZStack {
            Spacer()
                .background(themeManager.theme.background)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                buildListItem(item: buildLabel(title: "Manage Account", systemImage: "person"))
                buildListItem(item: buildLabel(title: "FAQ", systemImage: "questionmark"))
                buildListItem(item: buildLabel(title: "Notifications", systemImage: "bell"))
                buildListItem(item: themeManager.isDarkMode ?
                              buildLabel(title: "Dark Mode", systemImage: "moon")
                              : buildLabel(title: "Light Mode", systemImage: "sun.max"))
                    .onTapGesture {
                        themeManager.toggleTheme()
                    }
                buildListItem(item: buildLabel(title: supabaseManager.authChangeEvent == .signedIn ? "Log Out" : "Log in / Sign up", systemImage: "hand.wave"))
                    .onTapGesture {
                        Task {
                            if supabaseManager.authChangeEvent == .signedIn {
                                await supabaseManager.logout()
                            } else {
                                shouldPresentSheet.toggle()
                            }
                        }
                    }
                    .sheet(isPresented: $shouldPresentSheet) {
                        AuthView(isPresented: $shouldPresentSheet)
//                            .frame(width: 300, height: 400)
//                            .clearModalBackground()
                    }
                
            }
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
            Capsule().fill(themeManager.theme.background)
            Capsule().stroke(themeManager.theme.text, lineWidth: 2)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
