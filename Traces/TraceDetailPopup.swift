//
//  TraceDetailView.swift
//  Traces
//
//  Created by Bryce on 6/6/23.
//

import SwiftUI
import CoreData
import MapKit
import PopupView


struct TraceDetailPopup: CentrePopup {
    
    func configurePopup(popup: CentrePopupConfig) -> CentrePopupConfig {
        popup.horizontalPadding(10)

    }
    
    var trace: Trace
    @State var username: String = ""
    @State var region = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889)
    
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var supabaseManager = SupabaseManager.shared

    init(trace: Trace) {
        self.trace = trace
        self.region = CLLocationCoordinate2D(latitude: trace.latitude, longitude: trace.longitude)
        getUsername(trace.userID)
    }
    
    func getUsername(_ id: UUID) {
        Task {
            self.username = await supabaseManager.getUsernameFromID(id)
        }
    }
    
    func createContent() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(themeManager.theme.background)
            RoundedRectangle(cornerRadius: 24)
                .stroke(themeManager.theme.border, lineWidth: 2)
            VStack(spacing: 20) {
                HStack {
                    createMap()
                    Spacer()
                    VStack(alignment: .trailing) {
                        createTitle()
                        Spacer()
                        createUsername()
                        createDate()
                    }
                    .frame(height: 144)
                    .padding(6)
                }
                createCategory()
                createDescription()
                Divider()
                HStack(spacing: 24) {
                    Spacer()
                    cancelButton()
                    shareButton()
                }
            }
            .task {
                print(trace.locationName)
            }
            .padding()
        }
        .frame(height: 600)
    }
}

extension TraceDetailPopup {
    func createMap() -> some View {
        MapBox(mapType: .fixed)
            .clipShape(RoundedRectangle(cornerRadius: 29))
            .frame(width: 144, height: 144)
            .padding(4)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(themeManager.theme.border, lineWidth: 4)
                    RoundedRectangle(cornerRadius: 32)
                        .fill(themeManager.theme.background)
                }
            )
    }
    
    func createTitle() -> some View {
        Text(trace.locationName)
            .font(.title2)
            .foregroundColor(themeManager.theme.text)
    }
    
    func createDate() -> some View {
        Text(Date().formatted())
            .font(.caption)
            .foregroundColor(themeManager.theme.text)
    }
    
    func createCategory() -> some View {

        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(trace.categories, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
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
                        .padding(2)
                        .foregroundColor(themeManager.theme.text)
                }
            }
        }
    }
    
    func createDescription() -> some View {
        VStack {
            Text("Notes")
                .foregroundColor(themeManager.theme.text)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Gradient(colors: [themeManager.theme.background, themeManager.theme.backgroundAccent]))
                )
                .offset(x: -100, y: 20)
                .zIndex(1)
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .stroke(themeManager.theme.border, lineWidth: 2)
                RoundedRectangle(cornerRadius: 32)
                    .fill(themeManager.theme.backgroundAccent)
                VStack {
                    Text(trace.content)
                        .foregroundColor(themeManager.theme.text)
                    Spacer()
                }
                .padding()
            }
        }

    }
    
    func createUsername() -> some View {
        return Text(username)
            .font(.caption)
            .foregroundColor(themeManager.theme.text)
            .task {
                username = await supabaseManager.getUsernameFromID(trace.userID)
            }
    }
    
    
    func shareButton() -> some View {
        Button(action: {
            PopupManager.dismiss()
        }) {
            HalfButton(icon: "square.and.arrow.up.circle")
        }
    }
    func cancelButton() -> some View {
        Button(action: {
            PopupManager.dismiss()
        }) {
            HalfButton(icon: "xmark.circle")
                .rotationEffect(.degrees(180))
        }
    }
}
