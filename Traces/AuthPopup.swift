////
////  AuthView.swift
////  Traces
////
////  Created by Bryce on 6/8/23.
////
//
//import Foundation
//import GoTrue
//import SwiftUI
//import PopupView
//
//struct AuthPopup: CentrePopup {
//
//    func configurePopup(popup: CentrePopupConfig) -> CentrePopupConfig {
//        popup.horizontalPadding(10);
//    }
//
//    enum Mode {
//        case signIn, signUp
//    }
//
//    @State var email = ""
//    @State var password = ""
//    @State var mode: Mode = .signUp
//    @State var error: Error?
//    @State var loginInProgress: Bool = false
//    @ObservedObject var themeManager = ThemeManager.shared
//
//    func createContent() -> some View {
//        ZStack {
//            createBody()
//            if loginInProgress {
//                CircularProgressView()
//            }
//        }
//
//
//    }
//
//    func primaryActionButtonTapped() async {
//        do {
//            error = nil
//            switch mode {
//                case .signIn:
//                    try await supabase.auth.signIn(email: email, password: password)
//                    PopupManager.dismiss()
//                case .signUp:
//                    try await supabase.auth.signUp(email: email, password: password)
//                    PopupManager.dismiss()
//                }
//        } catch {
//            withAnimation {
//                self.error = error
//            }
//        }
//    }
//}
//
//extension AuthPopup {
//    func createBody() -> some View {
//        VStack {
//            Spacer()
//            Text("Welcome to Traces")
//                .font(.title2)
//                .fontWeight(.bold)
//            //            Text("Enter your login info below")
//            Spacer()
//            TextField("Email", text: $email)
//                .keyboardType(.emailAddress)
//                .textContentType(.emailAddress)
//                .autocorrectionDisabled()
//                .textInputAutocapitalization(.never)
//                .padding(16)
//                .background(
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(.white))
//            SecureField("Password", text: $password)
//                .textContentType(.password)
//                .autocorrectionDisabled()
//                .textInputAutocapitalization(.never)
//                .padding(16)
//                .background(
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(.white))
//            if mode == .signUp {
//                SecureField("Confirm Password", text: $password)
//                    .textContentType(.password)
//                    .autocorrectionDisabled()
//                    .textInputAutocapitalization(.never)
//                    .padding(16)
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(.white))
//            }
//            Spacer()
//            buildButtons()
//            Spacer()
//            if let error {
//                Text(error.localizedDescription)
//            }
//            //            Spacer()
//            //            Button(mode == .signIn ? "Sign in" : "Sign up") {
//            //                Task {
//            //                    await primaryActionButtonTapped()
//            //                }
//            //            }
//        }
//        .padding()
//        .background(snow)
//        .frame(height: 480)
//    }
//}
//
//extension AuthPopup {
//
//    func buildButtons() -> some View {
//        VStack {
//            buildSignupButton()
//            buildSigninButton()
//        }
//    }
//
//    private func buildSigninButton() -> some View {
//        HStack {
//            Spacer()
//            Button(action: {
//                if mode == .signIn {
//                    print("signing in")
//                    //Sign in user
//                }
//                withAnimation{ mode = (mode == .signIn) ? .signUp : .signIn}
//            }) {
//                Text(mode == .signUp ? "Sign in instead".uppercased() : "sign up instead".uppercased())
//                    .fontWeight(.bold)
//                    .padding(16)
//            }
//            Spacer()
//        }
//        .foregroundColor(themeManager.theme.accent)
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(themeManager.theme.accent, lineWidth: 2))
//    }
//
//    private func buildSignupButton() -> some View {
//        HStack {
//            Button(action: {
//                if mode == .signUp {
//                    //Sign Up USER
//                }
//                withAnimation { mode = .signUp }
//            }) {
//                Spacer()
//                Text(mode == .signIn ? "Sign In".uppercased() : "Sign Up".uppercased())
//                    .fontWeight(.bold)
//                    .padding(16)
//                Spacer()
//            }
//            .background(RoundedRectangle(cornerRadius: 12)
//                .fill(themeManager.theme.accent))
//            .foregroundColor(.white)
//        }
//    }
//}
//
//struct AuthPopup_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthPopup()
//    }
//}
