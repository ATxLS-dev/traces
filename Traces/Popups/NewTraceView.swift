//
//  NewTraceView.swift
//  Traces
//
//  Created by Bryce on 8/27/23.
//

import SwiftUI
import CoreData
import MapKit
import PopupView

struct NewTraceView: View {
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State var region = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889)
    @State var showFilterDropdown: Bool = false
    @State var showNoteEditor: Bool = false
    @State var tags: Set<String> = []
    
    @Binding var isPresented: Bool
    
    @ObservedObject var themeController = ThemeController.shared
    @ObservedObject var supabaseController = SupabaseController.shared
    @ObservedObject var locationController = LocationController.shared
    @ObservedObject var auth = AuthController.shared
    @ObservedObject var notificationController = NotificationController.shared
    
    var body: some View {
        ZStack {
            if auth.authChangeEvent != .signedIn {
                createNotLoggedInView()
            } else {
                createBody()
            }
        }
    }
    
    func createBody() -> some View {
        ZStack {
            ZStack {
                BorderedRectangle(cornerRadius: 24)
                VStack(spacing: 28) {
                    HStack {
                        createMap()
                        Spacer()
                        createPrompt()
                        Spacer()
                    }
                    categorySelector()
                        .zIndex(1)
                    createField()
                    if showNoteEditor {
                        createEditor()
                    } else {
                        addDescription()
                    }
                    HStack(spacing: 4) {
                        Spacer()
                        cancelButton()
                        submitButton()
                    }
                }
                .padding(16)
            }
            .frame(height: 480)
            .onTapGesture {
                if showFilterDropdown {
                    showFilterDropdown.toggle()
                }
            }
        }
        .padding()
        .onAppear {
            locationController.snapshotLocation()
            
        }
    }
    
    func createNotLoggedInView() -> some View {
        ZStack {
            VStack() {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .foregroundColor(themeController.theme.text)
                        .scaleEffect(1.4)
                        .padding(36)
                }
                Spacer()
            }
            Text("You'll need an account to leave traces.")
                .foregroundColor(themeController.theme.text)
        }
        .frame(height: 480)
        .padding()
        .background(BorderedRectangle(cornerRadius: 24))
        .onTapGesture {
            PopupManager.dismiss()
        }
    }
}

private extension NewTraceView {
    func createMap() -> some View {
        MapBox()
            .clipShape(RoundedRectangle(cornerRadius: 29))
            .frame(width: 144, height: 144)
            .padding(4)
            .background( BorderedRectangle() )
    }
    
    func createPrompt() -> some View {
        Text("Leave a trace?")
            .foregroundColor(themeController.theme.text)
            .font(.title3)
    }
    
    func createField() -> some View {
        ZStack {
            TextField("", text: $title)
                .textFieldStyle(.plain)
                .foregroundColor(themeController.theme.text)
                .padding(20)
                .background( BorderedCapsule() )
            FieldLabel(fieldLabel: "Title")
                .offset(x: -100, y: -30)
        }
    }
    
    func addDescription() -> some View {
        Button("Add any notes", action: {showNoteEditor.toggle()})
    }
    
    func buildTagCapsule(_ tag: String) -> some View {
        Button(action: {
            tags.remove(tag)
        }) {
            HStack(spacing: 12) {
                Text(tag)
                    .font(.caption)
                Image(systemName: "x.circle")
                    .foregroundColor(themeController.theme.accent.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    Capsule()
                        .fill(themeController.theme.background)
                    Capsule()
                        .stroke(themeController.theme.accent, lineWidth: 1.4)
                }
            )
            .foregroundColor(themeController.theme.text)
        }
        .padding(2)
    }
    
    func categorySelector() -> some View {
        ZStack {
            Spacer()
                .background(.ultraThinMaterial)
                .opacity(showFilterDropdown ? 0.8 : 0.0)
                .animation(.easeInOut(duration: 0.4), value: showFilterDropdown)
            VStack {
                HStack {
                    if !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(tags), id:\.self) { tag in
                                    buildTagCapsule(tag)
                                }
                            }.transition(AnyTransition.scale)
                        }
                    }
                    Spacer()
                    sortButton()
                }
                .padding(4)
                .padding(.leading)
                .background(
                    ZStack {
                        BorderedCapsule()
                        FieldLabel(fieldLabel: "Tags")
                            .offset(x: -102, y: -30)
                    }
                )
                .onTapGesture {
                    showFilterDropdown.toggle()
                }
            }
            VStack {
                if showFilterDropdown {
                    buildTagPicker()
                        .offset(y: -200)
                        .zIndex(1)
                        .transition(.move(edge: self.showFilterDropdown ? .leading : .trailing))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: self.showFilterDropdown)
        }
    }
    
    func buildTagPicker() -> some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(supabaseController.categories) { tag in
                        Button(action: {
                            withAnimation { () -> () in
                                tags.insert(tag.name)
                            }
                        }) {
                            HStack {
                                Text(tag.name)
                                    .font(.body)
                                    .foregroundColor(themeController.theme.text)
                                    .padding(4)
                                Spacer()
                                if tags.contains(tag.name) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(themeController.theme.accent)
                                        .padding(.trailing, 6)
                                }
                            }
                            .frame(width: 220)
                        }
                    }
                }
            }
            .frame(height: 480)
            .padding(12)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24).foregroundColor(themeController.theme.backgroundAccent)
                    RoundedRectangle(cornerRadius: 24).stroke(themeController.theme.border, lineWidth: 2)
                }
            )
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
    
    func sortButton() -> some View {
        Button(action: {
            showFilterDropdown.toggle()
        }) {
            BorderedHalfButton()
        }
    }
    
    
    func createEditor() -> some View {
        ZStack {
            TextField("", text: $content)
                .textFieldStyle(.plain)
                .foregroundColor(themeController.theme.text)
                .padding(20)
                .background( BorderedCapsule() )
            FieldLabel(fieldLabel: "Any other notes?")
                .offset(x: -60, y: -30)
        }
    }
    
    func submitButton() -> some View {
        Button(action: {
            supabaseController.createNewTrace(
                locationName: title,
                content: content,
                categories: Array(tags),
                location: locationController.userLocation)
            isPresented.toggle()
            notificationController.sendNotification(.traceCreated)
        }) {
            BorderedHalfButton(icon: "checkmark.circle")
        }
    }
    func cancelButton() -> some View {
        Button(action: {
            isPresented.toggle()
        }) {
            BorderedHalfButton(icon: "xmark.circle", noBorderColor: true, noBackgroundColor: true)
                .rotationEffect(.degrees(180))
        }
    }
}

#Preview {
    NewTraceView(isPresented: .constant(true))
}
