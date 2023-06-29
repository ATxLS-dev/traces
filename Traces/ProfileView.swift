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
    
    @State var error: Error?
    @ObservedObject var supabaseManager = SupabaseManager.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @State var shouldPresentSheet: Bool = false
    
    var body: some View {
        if supabaseManager.authChangeEvent == .signedOut {
            buildSignInButton()
        } else {
            buildProfilePage()
                .onAppear {
                    loadUserProfile()
                }
                .onChange(of: supabaseManager.authChangeEvent) { _ in
                    loadUserProfile()
                }
        }
    }
    
    func loadUserProfile() {
        guard let userID = supabaseManager.userID else {
            return
        }
        Task {
            await supabaseManager.loadTracesFromUser(userID)
        }
    }

    @ViewBuilder
    func buildSignInButton() -> some View {
        VStack {
            Label("Log in / Sign up", systemImage: "hand.wave")
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
                Text(supabaseManager.session?.user.email ?? "---")
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
                ForEach(supabaseManager.userTraceHistory) { trace in
                    HStack {
                        Button(action: TraceDetailView(trace: trace).showAndStack) {
                            TraceTile(trace: trace)
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer(minLength: 72)
            }
            .task {
                let userID = supabaseManager.session?.user.id ?? UUID()
                await supabaseManager.loadTracesFromUser(userID)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}



//struct ProfileView: View {
//
//    @State var error: Error?
//    @ObservedObject var supabaseManager = SupabaseManager.shared
//    @ObservedObject var themeManager = ThemeManager.shared
//    @ObservedObject var authManager = AuthManager.shared
//    @State var shouldPresentSheet: Bool = false
//    @State private var reloadView = false
//
//    init() {
//        // Add observation of authChangeEvent
//        authManager.$authChangeEvent
//            .sink { _ in }
//            .store(in: &cancellables)
//    }
//
//    @State private var cancellables: Set<AnyCancellable> = []
//
//    var body: some View {
//        Group {
//            if (authManager.authChangeEvent == .signedOut) {
//                buildSignInButton()
//            } else {
//                buildProfilePage()
//            }
//        }
//        .id(reloadView) // Use the reload flag as an identifier for the view
//    }
//
//    func reload() {
//        reloadView.toggle() // Toggle the reload flag to force a view reload
//    }
//}
//
//extension ProfileView {
//    func buildSignInButton() -> some View {
//        Label("Log in / Sign up", systemImage: "hand.wave")
//            .onTapGesture {
//                shouldPresentSheet.toggle()
//            }
//            .padding()
//            .sheet(isPresented: $shouldPresentSheet) {
//                AuthView(isPresented: $shouldPresentSheet)
//                //                            .frame(width: 300, height: 400)
//                //                            .clearModalBackground()
//            }
//    }
//}
//
//extension ProfileView {
//    func buildProfilePage() -> some View {
//        ScrollView {
//            HStack {
//                Image(systemName: "person.fill")
//                    .padding(10)
//                    .background(Circle().fill(themeManager.theme.text))
//                    .foregroundColor(themeManager.theme.background)
//                    .scaleEffect(2)
//                Spacer()
//                Text(authManager.session?.user.email ?? "---")
//                    .foregroundColor(themeManager.theme.text)
//                    .font(.body)
//            }
//            .padding(64)
//            Spacer()
//            buildProfileTraces()
//        }
//    }
//
//    func buildProfileTraces() -> some View {
//            ScrollView(.vertical, showsIndicators: false) {
//                VStack(spacing: 10) {
//                    ForEach(
//                        supabaseManager.userTraceHistory
//                    ) { trace in
//                        HStack {
//                            Button(action: TraceDetailView(trace: trace).showAndStack) {
//                                TraceTile(trace: trace)
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    Spacer(minLength: 72)
//                }
//                .task {
//                    let userID = authManager.session?.user.id ?? UUID()
//                    await supabaseManager.loadTracesFromUser(userID)
//                }
//        }
//    }
//}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
