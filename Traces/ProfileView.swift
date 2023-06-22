//
//  ProfileView.swift
//  Traces
//
//  Created by Bryce on 6/8/23.
//

import SwiftUI
import PopupView
import GoTrue

struct ProfileView: View {
    
    @State var authEvent: AuthChangeEvent?
    @EnvironmentObject var authController: AuthController
    @State var error: Error?
    @ObservedObject var supabaseManager = SupabaseManager.shared
    @ObservedObject var themeManager = ThemeManager.shared
    
    var body: some View {
        Group {
            if authEvent == .signedOut {
                buildSignInButton()
            } else {
                buildProfilePage()
            }
        }
        .background(themeManager.theme.background)

    }
}

extension ProfileView {
    func buildSignInButton() -> some View {
        Button(action: AuthPopup().showAndStack) {
            Text("Sign in?")
        }
        .padding()
    }
}

extension ProfileView {
    func buildProfilePage() -> some View {
        ScrollView {
            HStack {
                Image(systemName: "person.fill")
                    .padding(10)
                    .background(Circle().fill(themeManager.theme.text))
                    .foregroundColor(themeManager.theme.background)
                    .scaleEffect(2)
                Spacer()
                Text("Charlie Bean")
                    .foregroundColor(themeManager.theme.text)
                    .font(.title)
            }
            .padding(64)
            Spacer()
            buildProfileTraces()
        }
    }
    
    func buildProfileTraces() -> some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(
                        supabaseManager.filteredTraces.isEmpty ?
                        supabaseManager.traces : supabaseManager.filteredTraces
                    ) { trace in
                        HStack {
                            Button(action: TraceDetailView(trace: trace).showAndStack) {
                                TraceTile(trace: trace)
                            }
                        }
                        .padding(.horizontal)
                    }
                    Spacer(minLength: 72)
                }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
