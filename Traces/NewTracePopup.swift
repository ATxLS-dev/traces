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
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var themeManager = ThemeManager.shared

    @ObservedObject var supabaseManager = SupabaseManager.shared

    func createContent() -> some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(themeManager.theme.background)
                RoundedRectangle(cornerRadius: 28)
                    .stroke(themeManager.theme.text, lineWidth: 2)
                VStack(spacing: 10) {
                    HStack {
                        createMap()
                        Spacer()
                        createPrompt()
                            .padding()
                    }
                    Spacer()
                    filterBar()
                    Spacer()
                    createField()
                    Spacer()
                    if showNoteEditor {
                        createEditor()
                    } else {
                        addDescription()
                    }
                    Spacer()
                    HStack(spacing: 24) {
                        Spacer()
                        cancelButton()
                        submitButton()
                    }
                }
                .padding(16)
            }

            .frame(height: 480)
            if showFilterDropdown {
                FilterDropdown()
                    .transition(.move(edge: self.showFilterDropdown ? .leading : .trailing))
            }
        }

        .animation(.easeInOut(duration: 0.5), value: self.showFilterDropdown)
    }
//    private func addEntry(username: String = "New", content: String = "Nothing") {
//        withAnimation {
//            let newTrace: Trace
//            newTrace.creationDate = Date()
//            newTrace.id = UUID()
//            newTrace.username = username
//            newTrace.content = content
//            do {
//                try viewContext.save()
//            } catch {
//                print("Save Failed")
//            }
//        }
//    }
    
}

private extension NewTracePopup {
    func createMap() -> some View {
        MapBox(center: region)
            .clipShape(RoundedRectangle(cornerRadius: 29))
            .frame(width: 144, height: 144)
            .padding(4)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(themeManager.theme.text, lineWidth: 4)
                    RoundedRectangle(cornerRadius: 32)
                        .fill(themeManager.theme.background)
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
                .padding(20)
                .background(
                    ZStack {
                        Capsule()
                            .fill(themeManager.theme.background)
                        Capsule()
                            .stroke(themeManager.theme.text, lineWidth: 2)
                    }
                )
            Text("Title")
                .font(.subheadline)
                .padding(.horizontal)
                .background(
                    Rectangle()
                        .fill(themeManager.theme.background)
                )
                .offset(x: -100, y: -30)
        }
    }
    
    func addDescription() -> some View {
        Button("add any notes?", action: {showNoteEditor.toggle()})
    }
    
    func sortButton() -> some View {
        Button(action: {
            showFilterDropdown.toggle()
        }) {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .scaleEffect(1.2)
                .foregroundColor(themeManager.theme.text)
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.theme.text, lineWidth: 2)
                            .clipShape(
                                Rectangle()
                                    .scale(1.1)
                                    .trim(from: 0.125, to: 0.625)
                                    .rotation(Angle(degrees: 180))
                            )
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(Angle(degrees: -90))
                            .stroke(themeManager.theme.text, lineWidth: 2)
                    }
                )
        }
    }
    
    func filterBar() -> some View {
        ZStack {
            Spacer()
                .background(.ultraThinMaterial)
                .opacity(showFilterDropdown ? 0.8 : 0.0)
                .animation(.easeInOut(duration: 0.4), value: showFilterDropdown)
            VStack {
                HStack {
                    if !supabaseManager.filters.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(supabaseManager.filters), id: \.self) { category in
                                    CategoryTag(category: category)
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
                        Capsule().fill(themeManager.theme.background)
                        Capsule().stroke(themeManager.theme.text, lineWidth: 2)
                        Text("Tag")
                            .font(.subheadline)
                            .padding(.horizontal)
                            .background(
                                Rectangle()
                                    .fill(themeManager.theme.background)
                            )
                            .offset(x: -100, y: -30)
                    }
                )
                .onTapGesture {
                    showFilterDropdown.toggle()
                }
            }
        }
    }

    
    func createEditor() -> some View {
        TextEditor(text: $content)
            .scrollContentBackground(.hidden)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(themeManager.theme.text, lineWidth: 4)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(themeManager.theme.background)
                }
            )
            .frame(height: 150)
    }

    func submitButton() -> some View {
        Button(action: {
            
        }) {
            Image(systemName: "checkmark.circle")
                .scaleEffect(1.2)
                .foregroundColor(themeManager.theme.text)
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(themeManager.theme.button)
                            .clipShape(
                                Rectangle()
                                    .scale(2)
                                    .trim(from: 0, to: 0.5)
                                    .rotation(Angle(degrees: -120))
                            )
                            .frame(width: 90)
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(Angle(degrees: -90))
                            .fill(themeManager.theme.button)
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.theme.text, lineWidth: 2)
                            .clipShape(
                                Rectangle()
                                    .scale(2)
                                    .trim(from: 0, to: 0.5)
                                    .rotation(Angle(degrees: -120))
                            )
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(Angle(degrees: -90))
                            .stroke(themeManager.theme.text, lineWidth: 2)
                        
                }
            )
        }
    }
    func cancelButton() -> some View {
        Button(action: {
            PopupManager.dismiss()
        }) {
            Image(systemName: "xmark.circle")
                .scaleEffect(1.2)
                .foregroundColor(themeManager.theme.text)
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.theme.text, lineWidth: 2)
                            .clipShape(
                                Rectangle()
                                    .scale(1.1)
                                    .trim(from: 0.125, to: 0.625)
                                    .rotation(Angle(degrees: 0))
                            )
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(Angle(degrees: 90))
                            .stroke(themeManager.theme.text, lineWidth: 2)
                    }
                )
        }
    }
}

struct NewTracePopup_Previews: PreviewProvider {
    static var previews: some View {
        NewTracePopup()
    }
}
