//
//  AuthView.swift
//  Traces
//
//  Created by Bryce on 6/27/23.
//

import SwiftUI

struct AuthView: View {

    @State var email = ""
    @State var password = ""
    @State var mode: Mode?
    @State var error: Error?
    @State var errorMessage: String?
    @State var loginInProgress: Bool = false
    @Binding var isPresented: Bool
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var authManager = AuthManager.shared

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
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(themeManager.theme.text, lineWidth: 2))
            SecureField("Password", text: $password)
                .textContentType(.password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .background(
                    Capsule()
                        .stroke(themeManager.theme.text, lineWidth: 2))
            if mode == .signUp {
                SecureField("Confirm Password", text: $password)
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
                            try await authManager.createNewUser(email: email, password: password)
                            try await authManager.login(email: email, password: password)
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
                        try await authManager.login(email: email, password: password)
                        self.isPresented = false
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
            }
            Spacer()
        }
        .background(
            Capsule()
                .stroke(themeManager.theme.accent, lineWidth: 2))
        
    }


}
//
//struct AuthView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthView()
//    }
//}
