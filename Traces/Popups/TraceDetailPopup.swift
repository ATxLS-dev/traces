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
    
    @EnvironmentObject var theme: ThemeController
    @ObservedObject var supabaseController = SupabaseController.shared
    @ObservedObject var notificationController = NotificationController.shared

    init(trace: Trace) {
        self.trace = trace
        self.region = CLLocationCoordinate2D(latitude: trace.latitude, longitude: trace.longitude)
        getUsername(trace.userID)
    }
    
    func getUsername(_ id: UUID) {
        Task {
            self.username = await supabaseController.getFromID(id, column: "username")
        }
    }
    
    func createContent() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(theme.background)
            RoundedRectangle(cornerRadius: 24)
                .stroke(theme.border, lineWidth: 2)
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
                Spacer()
                HStack() {
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
        .frame(height: 480)
    }
}

extension TraceDetailPopup {
    func createMap() -> some View {
        MapBox(focalTrace: trace)
            .clipShape(RoundedRectangle(cornerRadius: 29))
            .frame(width: 144, height: 144)
            .padding(4)
            .background( BorderedRectangle() )
    }
    
    func createTitle() -> some View {
        Text(trace.locationName)
            .font(.title2)
            .foregroundColor(theme.text)
    }
    
    func createDate() -> some View {
        Text(Date().formatted())
            .font(.caption)
            .foregroundColor(theme.text)
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
                            BorderedCapsule(hasThinBorder: true)
                                .shadow(color: theme.shadow, radius: 4, x: 2, y: 2)
                        )
                        .padding(2)
                        .foregroundColor(theme.text)
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    func createDescription() -> some View {
        VStack {
            FieldLabel(fieldLabel: "Notes")
                .offset(x: -100, y: 20)
                .zIndex(1)
            ZStack {
                BorderedRectangle(cornerRadius: 24, accented: true)
                HStack {
                    Text(trace.content)
                        .foregroundColor(theme.text)
                    Spacer()
                }
                .padding()
            }
        }

    }
    
    func createUsername() -> some View {
        return Text(username)
            .font(.caption)
            .foregroundColor(theme.text)
            .task {
                username = await supabaseController.getFromID(trace.userID, column: "username")
            }
    }
    
    
    func shareButton() -> some View {
        Button(action: {
            notificationController.sendNotification(.linkCopied)
            PopupManager.dismiss()
            
        }) {
            BorderedHalfButton(icon: "square.and.arrow.up.circle")
        }
    }
    
    func cancelButton() -> some View {
        Button(action: {
            PopupManager.dismiss()
        }) {
            BorderedHalfButton(icon: "xmark.circle", noBorderColor: true, noBackgroundColor: true)
                .rotationEffect(.degrees(180))
        }
    }
}
