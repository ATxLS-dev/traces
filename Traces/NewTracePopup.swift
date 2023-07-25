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

    func createContent() -> some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(themeManager.theme.background)
                RoundedRectangle(cornerRadius: 28)
                    .stroke(themeManager.theme.border, lineWidth: 2)
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
            locationManager.updateUserLocation()
            
        }
    }
}

private extension NewTracePopup {
    func createMap() -> some View {
        MapBox(mapType: .newTrace)
            .clipShape(RoundedRectangle(cornerRadius: 29))
            .frame(width: 144, height: 144)
            .padding(4)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(themeManager.theme.border, lineWidth: 4)
                    RoundedRectangle(cornerRadius: 32)
                        .fill(themeManager.theme.backgroundAccent)
                }
            )
    }
    
    func createPrompt() -> some View {
        Text("Leave a trace?")
            .foregroundColor(themeManager.theme.text)
            .font(.title3)
    }
    
    func createField() -> some View {
        ZStack {
            TextField("", text: $title)
                .textFieldStyle(.plain)
                .foregroundColor(themeManager.theme.text)
                .padding(20)
                .background(
                    ZStack {
                        Capsule()
                            .fill(themeManager.theme.backgroundAccent)
                        Capsule()
                            .stroke(themeManager.theme.border, lineWidth: 2)
                    }
                )
            Text("Title")
                .foregroundColor(themeManager.theme.text)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Gradient(colors: [themeManager.theme.background, themeManager.theme.backgroundAccent]))
                )
                .offset(x: -100, y: -30)
        }
    }
    
    func addDescription() -> some View {
        Button("add any notes?", action: {showNoteEditor.toggle()})
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
                        Capsule().fill(themeManager.theme.backgroundAccent)
                        Capsule().stroke(themeManager.theme.border, lineWidth: 2)
                        Text("Tag")
                            .foregroundColor(themeManager.theme.text)
                            .font(.subheadline)
                            .padding(.horizontal)
                            .background(
                                Capsule()
                                    .fill(Gradient(colors: [themeManager.theme.background, themeManager.theme.backgroundAccent]))
                            )
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
                                tags.insert(tag.category)
                            }
                        }) {
                            HStack {
                                Text(tag.category)
                                    .font(.body)
                                    .foregroundColor(themeManager.theme.text)
                                    .padding(4)
                                Spacer()
                                if tags.contains(tag.category) {
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
            HalfButton()
        }
    }

    
    func createEditor() -> some View {
        TextEditor(text: $content)
            .scrollContentBackground(.hidden)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(themeManager.theme.border, lineWidth: 4)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(themeManager.theme.background)
                }
            )
            .frame(height: 150)
    }

    func submitButton() -> some View {
        Button(action: {
            supabaseManager.createNewTrace(
                locationName: title,
                content: content,
                categories: Array(tags),
                location: locationManager.lastLocation)
            PopupManager.dismiss()
        }) {
            HalfButton(icon: "checkmark.circle")
        }
    }
    func cancelButton() -> some View {
        Button(action: {
            PopupManager.dismiss()
        }) {
            HalfButton(icon: "xmark.circle", isColorless: true)
                .rotationEffect(.degrees(180))
        }
    }
}

struct NewTracePopup_Previews: PreviewProvider {
    static var previews: some View {
        NewTracePopup()
    }
}
