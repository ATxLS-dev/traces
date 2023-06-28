////
////  AuthController.swift
////  Traces
////
////  Created by Bryce on 6/8/23.
////
//
//import SwiftUI
//import GoTrue
//
//final class AuthController: ObservableObject {
//    
//    @Published var session: Session?
//    
//    var currentUserID: UUID {
//        guard let id = session?.user.id else {
//            preconditionFailure("Required session.")
//        }
//        
//        return id
//    }
//}
//
//struct AuthDemo: View {
//    enum Mode {
//        case signIn, signUp
//    }
//    
//    @EnvironmentObject var auth: AuthController
//    @Binding var isPresented: Bool
//    @State var email = ""
//    @State var password = ""
//    @State var mode: Mode = .signIn
//    @State var error: Error?
//
//    var body: some View {
//        Form {
//            Section {
//                TextField("Email", text: $email)
//                    .keyboardType(.emailAddress)
//                    .textContentType(.emailAddress)
//                    .autocorrectionDisabled()
//                    .textInputAutocapitalization(.never)
//                SecureField("Password", text: $password)
//                    .textContentType(.password)
//                    .autocorrectionDisabled()
//                    .textInputAutocapitalization(.never)
//                Button(mode == .signIn ? "Sign in" : "Sign up") {
//                    Task {
//                        await primaryActionButtonTapped()
//                    }
//                }
//                
//                if let error {
//                    Text(error.localizedDescription)
//                }
//            }
//            
//            Section {
//                Button(
//                    mode == .signIn ? "Don't have an account? Sign up." :
//                        "Already have an account? Sign in."
//                ) {
//                    withAnimation {
//                        mode = mode == .signIn ? .signUp : .signIn
//                    }
//                }
//            }
//        }
//    }
//    
//    func primaryActionButtonTapped() async {
//        do {
//            error = nil
//            //Loading indicator
//            switch mode {
//            case .signIn:
//                try await supabase.auth.signIn(email: email, password: password)
//                print("signed in")
//                isPresented = false
//                
//            case .signUp:
//                try await supabase.auth.signUp(email: email, password: password)
//                print("signed up")
//                isPresented = false
//            }
//        } catch {
//            withAnimation {
//                self.error = error
//            }
//        }
//    }
//}
//
////struct AuthDemo_Previews: PreviewProvider {
////
////    static var previews: some View {
////        AuthDemo()
////    }
////}
