//
//  ProfileSheetView.swift
//  Traces
//
//  Created by Bryce on 9/12/23.
//

import SwiftUI

struct ProfileSheetView: View {
    
    var userID: UUID
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var supabase: SupabaseController
    @EnvironmentObject var notifications: NotificationController
    @EnvironmentObject var theme: ThemeController
    
    @State var userTraces: [Trace] = []
    @State var shouldPresentSheet: Bool = false
    @State var shouldPresentPopover: Bool = false
    @State var username: String = ""
    @State var bio: String = ""
    @State var newBio: String = ""
    @State var error: String = ""
    
    let maxCharacters: Int = 280
    
    var body: some View {
        ZStack {
            Spacer()
                .background(theme.background)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            profilePage
                .onAppear {
                    loadUserProfile()
                }
            }
        }
    
    func loadUserProfile() {
        Task {
            await supabase.loadTracesFromUser(userID)
            userTraces = supabase.userTraceHistory
            bio = await supabase.getFromID(userID, column: "bio")
        }
    }
    
    var signInButton: some View {
        VStack {
            Label("Log in / Sign up", systemImage: "hand.wave")
                .foregroundColor(theme.text)
                .onTapGesture { shouldPresentSheet.toggle() }
                .padding()
                .background( BorderedCapsule() )
                .sheet(isPresented: $shouldPresentSheet) {
                    AuthView()
                }
        }
    }
    
    var profilePage: some View {
        ScrollView(showsIndicators: false) {
            Spacer(minLength: 48)
            HStack {
                Spacer()
                exitButton
            }
            .padding(.horizontal, 20)
            profileCard
            traceList
            Spacer(minLength: 128)
        }
    }
    
    var traceList: some View {
        VStack() {
            ForEach(userTraces) { trace in
                TraceTile(userHasOwnership: false, trace: trace)
            }
        }
    }
    
    var profileCard: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text("@\(username)")
                    .font(.title2)
                    .foregroundColor(theme.text)
                    .padding(.bottom,12)
                Text(bio)
                    .font(.caption)
                    .foregroundColor(theme.text.opacity(0.6))
            }
        }
        .padding(24)
        .task {
            username = await supabase.getFromID(userID, column: "username")
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    var exitButton: some View {
        Button(action: { dismiss() }) {
            ZStack {
                BorderedCapsule()
                    .frame(width: 48, height: 48)
                Image(systemName: "xmark")
                    .foregroundStyle(theme.text)
            }
        }
    }
}
