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
    @State var traces: [Trace] = []
    @State var error: Error?
    
    var body: some View {
        Group {
            if authEvent == .signedOut {
                buildSignInButton()
            } else {
                buildProfilePage()
            }
        }
    }
}

extension ProfileView {
    func buildSignInButton() -> some View {
        Button(action: AuthPopup().showAndStack) {
            Text("Sign in?")
        }
        .padding()
        .borderRadius(.black, cornerRadius: 10, corners: .allCorners)
    }
}

extension ProfileView {
    func buildProfilePage() -> some View {
        VStack {
            HStack {
                Image(systemName: "person")
                    .padding(8)
                    .background(Circle().fill(.black))
                    .foregroundColor(.white)
                    .scaleEffect(3)
                Spacer()
                Text("USERNAME")
            }
            .padding(64)
            Spacer()
            buildProfileTraces()
        }
    }
    func buildProfileTraces() -> some View {
        ScrollView {
            ForEach(traces) { trace in
                Button(action: TraceDetailView(trace: trace).showAndStack) {
                    TraceTile(trace: trace)
                }
            }
        }
        .task {
            await loadTraces()
        }
    }
    
    func loadTraces() async {
        let query = supabase.database.from("traces").select()
        Task {
            do {
                error = nil
                traces = try await query.execute().value
            } catch {
                self.error = error
                print(error)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
