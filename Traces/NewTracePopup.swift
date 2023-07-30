//
//  TracePopup.swift
//  Traces
//
//  Created by Bryce on 5/24/23.
//

import SwiftUI
import CoreData
import MapKit
import PopupView

struct NewTracePopup: CentrePopup {
    
    func configurePopup(popup: CentrePopupConfig) -> CentrePopupConfig {
        popup.horizontalPadding(10)
    }
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State var region = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889)
    @State var showFilterDropdown: Bool = false
    @State var showNoteEditor: Bool = false
    @State var tags: Set<String> = []
    
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var supabaseManager = SupabaseManager.shared
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var auth = AuthManager.shared
    @ObservedObject var notificationManager = NotificationManager.shared
    
    func createContent() -> some View {
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
        .onAppear {
            locationManager.snapshotLocation()
            
        }
    }
    
    func createNotLoggedInView() -> some View {
        ZStack {
            VStack() {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .scaleEffect(1.4)
                        .padding(36)
                }
                Spacer()
            }
            Text("You'll need an account to leave traces.")
        }
        .frame(height: 480)
        .background(BorderedRectangle())
        .padding()
        .onTapGesture {
            PopupManager.dismiss()
        }
    }
}

private extension NewTracePopup {
    func createMap() -> some View {
        MapBox()
            .clipShape(RoundedRectangle(cornerRadius: 29))
            .frame(width: 144, height: 144)
            .padding(4)
            .background( BorderedRectangle() )
    }
    
    func createPrompt() -> some View {
        Text("Make changes?")
            .foregroundColor(themeManager.theme.text)
            .font(.title3)
    }
    
    func createField() -> some View {
        ZStack {
            TextField("", text: $title)
                .textFieldStyle(.plain)
                .foregroundColor(themeManager.theme.text)
                .padding(20)
                .background( BorderedCapsule() )
            FieldLabel(fieldLabel: "Title")
                .offset(x: -100, y: -30)
        }
    }
    
    func addDescription() -> some View {
        Button("View notes?", action: {showNoteEditor.toggle()})
    }
    
    func buildTagCapsule(_ tag: String) -> some View {
        Button(action: {
            tags.remove(tag)
        }) {
            HStack(spacing: 12) {
                Text(tag)
                    .font(.caption)
                Image(systemName: "x.circle")
                    .foregroundColor(themeManager.theme.accent.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    Capsule()
                        .fill(themeManager.theme.background)
                    Capsule()
                        .stroke(themeManager.theme.accent, lineWidth: 1.4)
                }
            )
            .foregroundColor(themeManager.theme.text)
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
                    ForEach(supabaseManager.categories) { tag in
                        Button(action: {
                            withAnimation { () -> () in
                                tags.insert(tag.name)
                            }
                        }) {
                            HStack {
                                Text(tag.name)
                                    .font(.body)
                                    .foregroundColor(themeManager.theme.text)
                                    .padding(4)
                                Spacer()
                                if tags.contains(tag.name) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(themeManager.theme.accent)
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
                    RoundedRectangle(cornerRadius: 24).foregroundColor(themeManager.theme.backgroundAccent)
                    RoundedRectangle(cornerRadius: 24).stroke(themeManager.theme.border, lineWidth: 2)
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
        TextEditor(text: $content)
            .scrollContentBackground(.hidden)
            .background(
                BorderedRectangle()
            )
            .frame(height: 120)
    }
    
    func submitButton() -> some View {
        Button(action: {
            supabaseManager.createNewTrace(
                locationName: title,
                content: content,
                categories: Array(tags),
                location: locationManager.lastLocation)
            PopupManager.dismiss()
            notificationManager.sendNotification(.traceCreated)
        }) {
            BorderedHalfButton(icon: "checkmark.circle")
        }
    }
    func cancelButton() -> some View {
        Button(action: {
            PopupManager.dismiss()
        }) {
            BorderedHalfButton(icon: "xmark.circle", noBorderColor: true)
                .rotationEffect(.degrees(180))
        }
    }
}

struct NewTracePopup_Previews: PreviewProvider {
    static var previews: some View {
        NewTracePopup()
    }
}
