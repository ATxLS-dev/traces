//
//  AccountView.swift
//  Traces
//
//  Created by Bryce on 6/29/23.
//

import SwiftUI

struct AccountSheet: View {
    
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

extension AccountSheet {
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

extension AccountSheet {
    
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
                .foregroundColor(themeManager.theme.text)
            Spacer()
        }
        .background(
            Capsule()
                .stroke(themeManager.theme.border, lineWidth: 2))
    }
    
    private func editButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                isEditMode = true
            }) {
                Text("Edit Account Info")
                    .foregroundColor(themeManager.theme.text)
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

            }) {
                Text("Delete Account")
                    .foregroundColor(.red)
                    .padding(16)
                    .foregroundColor(themeManager.theme.text)
            }
            Spacer()
        }
        .background(
            Capsule()
                .stroke(themeManager.theme.border, lineWidth: 2))
    }
    
    private func editAccountFields() -> some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .background(
                    Capsule()
                        .stroke(themeManager.theme.border, lineWidth: 2)
                )
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.bottom)
            
            SecureField("Password", text: $password)
                .padding()
                .background(
                    Capsule()
                        .stroke(themeManager.theme.border, lineWidth: 2)
                )
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.bottom)
        }
    }
}

struct AccountSheet_Previews: PreviewProvider {
    static var previews: some View {
        AccountSheet(isPresented: .constant(true))
    }
}

