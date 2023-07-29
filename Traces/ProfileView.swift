//
//  ProfileView.swift
//  Traces
//
//  Created by Bryce on 6/8/23.
//
//

import SwiftUI
import PopupView
import GoTrue
import Combine

struct ProfileView: View {
    
    @ObservedObject var supabase = SupabaseManager.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var auth = AuthManager.shared
    
    @State var userTraces: [Trace] = []
    @State var shouldPresentSheet: Bool = false
    @State var username: String = ""
    
    var body: some View {
        ZStack {
            Spacer()
                .background(themeManager.theme.background)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            if auth.authChangeEvent != .signedIn {
                buildSignInButton()
            } else {
                buildProfilePage()
                    .onAppear {
                        loadUserProfile()
                    }
                    .onChange(of: auth.authChangeEvent) { _ in
                        loadUserProfile()
                    }
                    .onChange(of: supabase.userTraceHistory) { _ in
                        loadUserProfile()
                    }
            }
        }
    }
    
    func loadUserProfile() {
        guard auth.session?.user != nil else { return }
        Task {
            await supabase.loadTracesFromUser(auth.session?.user.id)
            userTraces = supabase.userTraceHistory
        }
    }

    @ViewBuilder
    func buildSignInButton() -> some View {
        VStack {
            Label("Log in / Sign up", systemImage: "hand.wave")
                .foregroundColor(themeManager.theme.text)
                .onTapGesture { shouldPresentSheet.toggle() }
                .padding()
                .background( BorderedCapsule() )
                .sheet(isPresented: $shouldPresentSheet) {
                    AuthView(isPresented: $shouldPresentSheet)
                }

        }
    }
    
    @ViewBuilder
    func buildProfilePage() -> some View {
        ScrollView {
            buildProfileCard()
            buildTraces()
            Spacer(minLength: 128)
        }
    }
    
    func buildTraces() -> some View {
        VStack(spacing: 10) {
            ForEach(userTraces) { trace in
                Button(action: TraceDetailPopup(trace: trace).showAndStack) {
                    TraceTile(userHasOwnership: true, trace: trace)
                }
            }
        }
    }
    
    func buildProfileCard() -> some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text("@\(username)")
                    .font(.title2)
                    .foregroundColor(themeManager.theme.text)
//                Text(auth.session?.user.email ?? "---")
//                    .font(.caption)
//                    .foregroundColor(themeManager.theme.text.opacity(0.6))
            }
            .padding(.trailing)
        }
        .padding(24)
        .task {
            username = await auth.getCurrentUsername()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
