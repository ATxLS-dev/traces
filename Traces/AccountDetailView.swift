//
//  AccountView.swift
//  Traces
//
//  Created by Bryce on 6/29/23.
//

import SwiftUI

struct AccountDetailView: View {
    
    @State var mode: Mode = .signIn
    @State var inEditMode: Bool = false
    @State var confirmed: Bool = false
    @State var newUsername: String = ""
    @State var username: String = ""
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

extension AccountDetailView {
    
    func createBody() -> some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Manage your account")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.theme.text)
                .padding(.bottom)
            
            buildField("Username", content: username, editable: true)
            buildField("Email", content: supabase.user?.email)
            buildField("User ID", content: supabase.user?.id.uuidString)
            buildField("Creation Date", content: supabase.user?.createdAt.formatted())
 
            buildButtons()
            Spacer()
        }
        .task {
            username = await supabase.getUsernameFromID(supabase.user!.id)
        }
        .padding()
        .background(themeManager.theme.background)
    }

    func buildField(_ fieldLabel: String, content: String? = "", editable: Bool = false) -> some View {
        ZStack {
            HStack {
                if inEditMode && editable {
                    TextField(content ?? "Not found", text: $newUsername)
                        .foregroundColor(themeManager.theme.text)
                        .padding()
                } else {
                    Text(content ?? "Not found")
                        .padding()

                }
                Spacer()
            }
            .padding(.horizontal, 8)
            .frame(height: 64)
            .foregroundColor(themeManager.theme.text)
            .background( BorderedCapsule() )
            FieldLabel(fieldLabel: fieldLabel)
                .offset(x: 84, y: -30)
        }
    }
}


extension AccountDetailView {
    
    func buildButtons() -> some View {
        VStack {
            editButton()
            deleteAccountButton()
        }
        .padding(.top)
    }
    
    private func editButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                if !inEditMode {
                    inEditMode.toggle()
                } else {
                    supabase.setUsername(newUsername)
                    username = newUsername
                    inEditMode.toggle()
                    isPresented.toggle()
                }
            }) {
                Text(inEditMode ? "Save" : "Edit Account Info")
                    .foregroundColor(themeManager.theme.text)
                    .fontWeight(.bold)
                    .padding(16)
            }
            Spacer()
        }
        .background(
            BorderedCapsule(hasColoredBorder: true)
        )
    }
    
    private func deleteAccountButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                if confirmed {
                    supabase.deleteAccount()
                } else {
                    confirmed.toggle()
                }
            }) {
                Text(confirmed ? "Are you sure?" : "Delete Account")
                    .foregroundColor(.red)
                    .padding(16)
                    .foregroundColor(themeManager.theme.text)
            }
            Spacer()
        }
        .background(BorderedCapsule())
        .opacity(inEditMode ? 1.0 : 0.0)
        .animation(.easeInOut, value: inEditMode)
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(isPresented: .constant(true))
    }
}

