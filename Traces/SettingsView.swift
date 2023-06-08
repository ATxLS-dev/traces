//
//  SettingsView.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List{
            Text("Account Settings")
            Text("FAQ")
            Text("Notifications")
            Text("Tip Jar :)")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
