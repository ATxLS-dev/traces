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
        guard supabase.user != nil else {
            return
        }
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
                .sheet(isPresented: $shouldPresentSheet) {
                    AuthView(isPresented: $shouldPresentSheet)
                }
        }
    }
    
    @ViewBuilder
    func buildProfilePage() -> some View {
        ScrollView {
            HStack {
                Image(systemName: "person.fill")
                    .padding(10)
                    .background(Circle().fill(themeManager.theme.text))
                    .foregroundColor(themeManager.theme.background)
                    .scaleEffect(2)
                Spacer()
                Text(supabase.session?.user.email ?? "---")
                    .foregroundColor(themeManager.theme.text)
                    .font(.body)
            }
            .padding(64)
            Spacer()
            buildProfileTraces()
        }
    }
    
    @ViewBuilder
    func buildProfileTraces() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ForEach(supabase.userTraceHistory) { trace in
                    HStack {
                        Button(action: TraceDetailPopup(trace: trace).showAndStack) {
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
