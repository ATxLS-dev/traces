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
    
    @ObservedObject var supabase = SupabaseController.shared
    @ObservedObject var themeController = ThemeController.shared
    @ObservedObject var notificationController = NotificationController.shared
    @ObservedObject var auth = AuthController.shared
    
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
            bio = await supabase.getFromID(auth.session!.user.id, column: "bio")
        }
    }

    @ViewBuilder
    func buildSignInButton() -> some View {
        VStack {
            Label("Log in / Sign up", systemImage: "hand.wave")
                .foregroundColor(themeController.theme.text)
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
                Image(systemName: "pencil")
                    .foregroundColor(themeController.theme.text.opacity(0.8))
                    .onTapGesture {
                        shouldPresentPopover.toggle()
                    }
                    .popover(isPresented: $shouldPresentPopover) {
                        buildBioPopover()
                    }
                Spacer(minLength: 20)
                Text("@\(username)")
                    .font(.title2)
                    .foregroundColor(themeController.theme.text)
                    .padding(.bottom,12)
                Text(bio)
                    .font(.caption)
                    .foregroundColor(themeController.theme.text.opacity(0.6))
            }
        }
        .padding(24)
        .task {
            username = await auth.getCurrentUsername()
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    @ViewBuilder
    func buildBioPopover() -> some View {
        VStack {
            Text("Edit your bio?")
                .font(.title2)
                .padding(.bottom, 12)
            ZStack {
                BorderedRectangle(cornerRadius: 16)
                    .frame(minWidth: 300, minHeight: 200)
                TextEditor(text: $newBio)
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: 280, maxHeight: 180)
                    .background(themeController.theme.background)
                    .onAppear {
                        newBio = bio
                    }
            }
            .padding(.bottom, 4)
            characterCounter
                .padding(.bottom, 12)
            HStack {
                Spacer()
                Button(action: {
                    self.shouldPresentPopover = false
                }) {
                    BorderedHalfButton(icon: "xmark", noBorderColor: true, noBackgroundColor: true)
                        .rotationEffect(.degrees(180))
                }
                Button(action: {
                    if newBio.count <= maxCharacters {
                        auth.setBio(newBio)
                        notificationController.sendNotification(.bioUpdated)
                        self.shouldPresentPopover = false
                    } else {
                        error = "Bio too long"
                    }
                }) {
                    BorderedHalfButton(icon: "checkmark")
                }
            }
            if error != "" {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .presentationCompactAdaptation(.none)
    }
    
    @ViewBuilder
    private var characterCounter: some View {
        HStack {
            Spacer()
            Text(String(newBio.count) + "/" + String(maxCharacters))
                .font(.caption)
                .opacity(0.6)
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//            .environmentObject(ThemeController())
//    }
//}
