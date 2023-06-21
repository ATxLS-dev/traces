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
    @EnvironmentObject var authController: AuthController
    @ObservedObject var themeManager = ThemeManager.shared
    
    var body: some View {
        
//        List{
//            Section {
//                Text("Account Settings")
//                Text("FAQ")
//                Text("Notifications")
//                Button(action: {themeManager.setTheme(themeChoice: .dark)}) {
//                    Text("Dark Mode")
//                }
//                Button(action: {themeManager.setTheme(themeChoice: .light)}) {
//                    Text("Light Mode")
//                }
//            }
//            .foregroundColor(themeManager.theme.text)
//            .listRowBackground(themeManager.theme.background)
//            Section {
//                if authEvent == .signedOut {
//                    Text("Log Out")
//                        .foregroundColor(.red)
//                } else {
//                    Text("Sign up/login")
//                }
//            }
//        }
        ZStack {
            Spacer()
                .background(themeManager.theme.background)
                .frame(width: .infinity, height: .infinity)
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
