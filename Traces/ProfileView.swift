//
//  ProfileView.swift
//  Traces
//
//  Created by Bryce on 6/8/23.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authController: AuthController
    
    var body: some View {
        Button(action: AuthPopup().showAndStack) {
            Text("Sign in?")
        }
        .padding()
        .borderRadius(.black, cornerRadius: 10, corners: .allCorners)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
