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
    
    var body: some View {
        List{
            Section {
                Text("Account Settings")
                Text("FAQ")
                Text("Notifications")
                Text("Tip Jar :)")
            }
            Section {
                if authEvent == .signedOut {
                    Text("Log Out")
                        .foregroundColor(.red)
                } else {
                    Text("Sign up/login")
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
