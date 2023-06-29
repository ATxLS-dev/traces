//
//  AccountView.swift
//  Traces
//
//  Created by Bryce on 6/29/23.
//

import SwiftUI

struct AccountView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var mode: Mode = .signIn
    @State var isEditMode: Bool = false
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

extension AccountView {
    func createBody() -> some View {
        VStack {
            Spacer()
            Text("Manage your account")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.theme.text)
                .padding(.bottom)
            
            if isEditMode {
                editAccountFields()
            } else {
                buildAccountItem(supabase.user?.email)
                buildAccountItem(supabase.user?.createdAt.formatted())
            }
            
            buildButtons()
            Spacer()
        }
        .padding()
        .background(themeManager.theme.background)
    }
}

extension AccountView {
    
    func buildButtons() -> some View {
        VStack {
            if isEditMode {
                saveButton()
            } else {
                editButton()
            }
            deleteAccountButton()
        }
        .padding(.top)
    }
    
    func buildAccountItem(_ info: String?) -> some View {
        HStack {
            Text(info ?? "Not set")
                .padding()
            Spacer()
        }
        .background(
            Capsule()
                .stroke(themeManager.theme.text, lineWidth: 2))
    }
    
    private func editButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                isEditMode = true
            }) {
                Text("Edit Account Info")
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
    
    private func saveButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                // Perform save action
                isEditMode = false
            }) {
                Text("Save")
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
    
    private func deleteAccountButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                if mode == .signIn {
                    // Sign in user
                }
                withAnimation { mode = (mode == .signIn) ? .signUp : .signIn }
            }) {
                Text("Delete Account")
                    .padding(16)
                    .foregroundColor(themeManager.theme.text)
            }
            Spacer()
        }
        .background(
            Capsule()
                .stroke(themeManager.theme.accent, lineWidth: 2))
    }
    
    private func editAccountFields() -> some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .background(
                    Capsule()
                        .stroke(themeManager.theme.text, lineWidth: 2)
                )
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.bottom)
            
            SecureField("Password", text: $password)
                .padding()
                .background(
                    Capsule()
                        .stroke(themeManager.theme.text, lineWidth: 2)
                )
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.bottom)
        }
    }
}
