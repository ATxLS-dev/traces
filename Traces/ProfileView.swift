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
    @State var shouldPresentSheet: Bool = false
    @State var username: String = ""
    
    var body: some View {
        ZStack {
            Spacer()
                .background(themeManager.theme.background)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            if supabase.authChangeEvent == .signedOut {
                buildSignInButton()
            } else {
                buildProfilePage()
                    .onAppear {
                        loadUserProfile()
                    }
                    .onChange(of: supabase.authChangeEvent) { _ in
                        loadUserProfile()
                    }
            }
        }
    }
    
    func loadUserProfile() {
        guard supabase.user != nil else { return }
        Task {
            await supabase.loadTracesFromUser()
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
        ZStack {
            ScrollView {
                Spacer(minLength: 128)
                buildTraces()
                Spacer(minLength: 128)
            }
            VStack {
                buildProfileCard()
                    .padding(24)
                Spacer()
            }
        }
    }
    
    func buildTraces() -> some View {
        VStack(spacing: 10) {
            ForEach(supabase.userTraceHistory) { trace in
                HStack {
                    Button(action: TraceDetailPopup(trace: trace).showAndStack) {
                        TraceTile(trace: trace)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    func buildProfileCard() -> some View {
        HStack {
            Image(systemName: "person.fill")
                .padding(12)
                .foregroundColor(themeManager.theme.background)
                .background(Circle().fill(themeManager.theme.text.opacity(0.6)))
                .scaleEffect(1.4)
            Spacer()
            VStack(alignment: .trailing) {
                Text("@\(username)")
                    .font(.body)
                    .foregroundColor(themeManager.theme.text)
                Text(supabase.session?.user.email ?? "---")
                    .font(.caption)
                    .foregroundColor(themeManager.theme.text.opacity(0.6))
            }
            .padding(.trailing)
        }
        .padding(18)
        .background( BorderedCapsule() )
        .task {
            username = await supabase.getUsernameFromID(supabase.user!.id)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
