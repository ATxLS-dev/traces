//
//  AuthView.swift
//  Traces
//
//  Created by Bryce on 6/8/23.
//

import GoTrue
import SwiftUI
import PopupView

struct AuthPopup: CentrePopup {
    
    func configurePopup(popup: CentrePopupConfig) -> CentrePopupConfig {
        popup.horizontalPadding(10);
    }
    
    enum Mode {
        case signIn, signUp
    }
    
//    @EnvironmentObject var auth: AuthController
    
    @State var email = ""
    @State var password = ""
    @State var mode: Mode = .signIn
    @State var error: Error?
    
    func createContent() -> some View {
        Form {
            Section {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                Button(mode == .signIn ? "Sign in" : "Sign up") {
                    Task {
                        await primaryActionButtonTapped()
                        
                        
                        //WAIT FOR LOGIN COMPLETE MESSAGE
                        
                    }
                }
                
                if let error {
                    ErrorText(error)
                }
            }
            
            Section {
                Button(
                    mode == .signIn ? "Don't have an account? Sign up." :
                        "Already have an account? Sign in."
                ) {
                    withAnimation {
                        mode = mode == .signIn ? .signUp : .signIn
                    }
                }
            }
        }
        .frame(height: 480)
    }
    
    func primaryActionButtonTapped() async {
        do {
            error = nil
            switch mode {
            case .signIn:
                try await supabase.auth.signIn(email: email, password: password)
                PopupManager.dismiss()
            case .signUp:
                try await supabase.auth.signUp(email: email, password: password)
                PopupManager.dismiss()
            }
        } catch {
            withAnimation {
                self.error = error
            }
        }
    }
}

struct AuthPopup_Previews: PreviewProvider {
    static var previews: some View {
        AuthPopup()
    }
}
