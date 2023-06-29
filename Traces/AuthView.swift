//
//  AuthView.swift
//  Traces
//
//  Created by Bryce on 6/27/23.
//

import SwiftUI

struct AuthView: View {

    @State var email: String = ""
    @State var password: String = ""
    @State var mode: Mode = .signIn
    @State var error: Error?
    @State var errorMessage: String?
    @State var loginInProgress: Bool = false
    @Binding var isPresented: Bool
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var supabase = SupabaseManager.shared

    enum Mode {
        case signIn, signUp
    }

    var body: some View {
        createBody()
    }
}

extension AuthView {
    func createBody() -> some View {
        VStack {
            Spacer()
            Text("Welcome to Traces")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.theme.text)
                .padding(.bottom)
            TextField("Email", text: $email)
                .foregroundColor(themeManager.theme.text)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(themeManager.theme.text, lineWidth: 2))
            SecureField("Password", text: $password)
                .foregroundColor(themeManager.theme.text)
                .textContentType(.password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .background(
                    Capsule()
                        .stroke(themeManager.theme.text, lineWidth: 2))
            if mode == .signUp {
                SecureField("Confirm Password", text: $password)
                    .foregroundColor(themeManager.theme.text)
                    .textContentType(.password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(
                        Capsule()
                            .stroke(themeManager.theme.text, lineWidth: 2))
            }
            buildButtons()
            Spacer()
            Text(errorMessage ?? "")
        }
        .padding()
        .background(themeManager.theme.background)
    }
}

extension AuthView {

    func buildButtons() -> some View {
        VStack {
            buildMainActionButton()
            buildModeToggle()
        }
        .padding(.top)
    }
    
    private func buildMainActionButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                if mode == .signUp {
                    Task {
                        do {
                            try await supabase.createNewUser(email: email, password: password)
                            try await supabase.login(email: email, password: password)
                            self.isPresented = false
                        } catch CreateUserError.signUpFailed(let errorMessage) {
                            self.errorMessage = errorMessage
                        } catch {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                    withAnimation { mode = .signUp }
                }
                if mode == .signIn {
                    Task {
                        do {
                            try await supabase.login(email: email, password: password)
                            self.isPresented = false
                        } catch {
                            self.errorMessage = "S"
                        }
                    }
                }
            }) {
                Text(mode == .signIn ? "Sign In".uppercased() : "Sign Up".uppercased())
                    .fontWeight(.bold)
                    .padding(16)
            }
            Spacer()
        }
        .background(
            Capsule()
                .fill(themeManager.theme.accent)
        )
    }

    private func buildModeToggle() -> some View {
        HStack {
            Spacer()
            Button(action: {
                if mode == .signIn {
                    //Sign in user
                }
                withAnimation{ mode = (mode == .signIn) ? .signUp : .signIn}
            }) {
                Text(mode == .signUp ? "Sign in instead".uppercased() : "sign up instead".uppercased())
                    .padding(16)
                    .foregroundColor(themeManager.theme.text)
            }
            Spacer()
        }
        .background(
            Capsule()
                .stroke(themeManager.theme.accent, lineWidth: 2))
        
    }


}

