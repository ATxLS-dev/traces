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
    
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var supabase = SupabaseManager.shared
    @State var shouldPresentAuthSheet: Bool = false
    @State var shouldPresentAccountSheet: Bool = false
    @State var shouldPresentFAQSheet: Bool = false
    
    var body: some View {
        ZStack {
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
                        AccountSheet(isPresented: $shouldPresentAccountSheet)
                    }
                buildListItem(item: buildLabel(title: "FAQ", systemImage: "questionmark"))
                    .onTapGesture {
                        shouldPresentFAQSheet.toggle()
                    }
                    .sheet(isPresented: $shouldPresentFAQSheet) {
                        FAQSheet(isPresented: $shouldPresentFAQSheet)
                    }
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
                    }
                Spacer()
                
            }
            .padding(.top, 69)
        }
        .foregroundColor(themeManager.theme.text)
        .background(themeManager.theme.background)
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
            ZStack {
                Capsule()
                    .fill(themeManager.theme.backgroundAccent)
                Capsule()
                    .stroke(themeManager.theme.border, lineWidth: 2)
            }
        )
        .padding(.horizontal)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
