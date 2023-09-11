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
    @ObservedObject var supabase = SupabaseController.shared
    @ObservedObject var auth = AuthController.shared
    @EnvironmentObject var theme: ThemeController

    enum Mode {
        case signIn, signUp
    }

    var body: some View {
        createBody()
    }
}

extension AuthView {
    func createBody() -> some View {
        ZStack {
            VStack (spacing: 16){
                HStack {
                    Spacer()
                    Button(action: {isPresented = false} ) {
                        Image(systemName: "xmark")
                            .foregroundColor(theme.text)
                            .padding()
                            .background(BorderedCapsule(hasColoredBorder: true, hasThinBorder: true))
                            .shadow(color: theme.shadow, radius: 4, x: 2, y: 2)
                    }
                }
                Text("Welcome to Traces")
                    .font(.title2)
                    .foregroundColor(theme.text)
                    .padding(.bottom)
                TextField("", text: $email)
                    .foregroundColor(theme.text)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(
                        ZStack {
                            BorderedCapsule()
                            FieldLabel(fieldLabel: "Email")
                                .offset(x: -100, y: -26)
                    })
                SecureField("",text: $password)
                    .foregroundColor(theme.text)
                    .textContentType(.password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(
                        ZStack {
                            BorderedCapsule()
                            FieldLabel(fieldLabel: "Password")
                                .offset(x: -88, y: -26)
                    })
                SecureField("", text: $password)
                    .foregroundColor(theme.text)
                    .textContentType(.password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(
                        ZStack {
                            BorderedCapsule()
                            FieldLabel(fieldLabel: "Confirm Password")
                                .offset(x: -60, y: -26)
                    })
                    .opacity(mode == .signUp ? 1.0 : 0.0)
                    .animation(.easeInOut, value: mode)
                buildButtons()
                Spacer()
                Text(errorMessage ?? "")
            }
            .padding()
        .background(theme.background)
        }
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
                            try await auth.createNewUser(email: email, password: password)
                            try await auth.login(email: email, password: password)
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
                            try await auth.login(email: email, password: password)
                            self.isPresented = false
                        } catch {
                            self.errorMessage = "Invalid Login Credentials"
                        }
                    }
                }
            }) {
                Text(mode == .signIn ? "Log In" : "Sign Up")
                    .bold()
                    .padding(16)
                    .foregroundColor(theme.text)
            }
            Spacer()
        }
        .background(
            BorderedCapsule(hasColoredBorder: true)
                .shadow(color: theme.shadow, radius: 4, x: 2, y: 2)
        )
    }

    private func buildModeToggle() -> some View {
        HStack {
            Spacer()
            Button(action: {
                withAnimation{ mode = (mode == .signIn) ? .signUp : .signIn}
            }) {
                Text(mode == .signUp ? "Log in instead" : "Sign up instead")
                    .padding(16)
                    .foregroundColor(theme.text)
            }
            Spacer()
        }
        .background(
            Capsule()
                .stroke(theme.accent, lineWidth: 2)
                .shadow(color: theme.shadow, radius: 4, x: 2, y: 2))
        
        
    }


}


