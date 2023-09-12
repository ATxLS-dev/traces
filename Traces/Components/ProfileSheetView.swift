//
//  ProfileSheetView.swift
//  Traces
//
//  Created by Bryce on 9/12/23.
//

import SwiftUI

struct ProfileSheetView: View {
    
    @Binding var userID: UUID
    
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
            buildProfilePage()
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
    
    @ViewBuilder
    func buildSignInButton() -> some View {
        VStack {
            Label("Log in / Sign up", systemImage: "hand.wave")
                .foregroundColor(theme.text)
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
        ScrollView(showsIndicators: false) {
            buildProfileCard()
            buildTraces()
            Spacer(minLength: 128)
        }
    }
    
    func buildTraces() -> some View {
        VStack() {
            ForEach(userTraces) { trace in
                TraceTile(userHasOwnership: true, trace: trace)
            }
        }
    }
    
    func buildProfileCard() -> some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Spacer(minLength: 20)
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
}

#Preview {
    ProfileSheetView(userID: .constant(UUID(uuidString: "7dd199fd-aead-48d9-8246-bc0a86eed806")!))
        .environmentObject(ThemeController())
        .environmentObject(NotificationController())
        .environmentObject(AuthController())
        .environmentObject(LocationController())
        .environmentObject(SupabaseController())
        .environmentObject(FeedController())
}
