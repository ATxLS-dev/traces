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
        popup.horizontalPadding(10);
    }
    
    @State var trace: Trace?
    @State var region = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889)
    
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var supabaseManager = SupabaseManager.shared

    
    init(trace: Trace? = nil) {
        if let trace = trace {
            self.trace = trace
            self.region = CLLocationCoordinate2D(latitude: trace.latitude, longitude: trace.longitude)
        }
    }
    
    func createContent() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(themeManager.theme.background)
            RoundedRectangle(cornerRadius: 28)
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
                    submitButton()
                }
            }
            .padding()
        }
        .frame(height: 600)
    }
}

extension TraceDetailPopup {
    func createMap() -> some View {
        MapBox(center: region)
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
        Text(trace?.locationName ?? "Location Name")
            .font(.title2)
            .foregroundColor(themeManager.theme.text)
    }
    
    func createDate() -> some View {
        Text(Date().formatted())
            .font(.caption)
            .foregroundColor(themeManager.theme.text)
    }
    
    func createCategory() -> some View {
        HStack {
            CategoryTag(category: trace?.category ?? "Category")
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
                    Text(trace?.content ?? "    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Vel risus commodo viverra maecenas accumsan lacus vel facilisis volutpat. Mauris a diam maecenas sed enim ut sem viverra aliquet.")
                        .foregroundColor(themeManager.theme.text)
                    Spacer()
                }
                .padding()
            }
        }

    }
    
    func createUsername() -> some View {
        Text(trace?.username ?? "@not-logged-in")
            .font(.caption)
            .foregroundColor(themeManager.theme.text)

    }
    
    func submitButton() -> some View {
        Button(action: {
            
        }) {
            Image(systemName: "xmark.circle")
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
                            .stroke(themeManager.theme.border, lineWidth: 2)
                            .clipShape(
                                Rectangle()
                                    .scale(2)
                                    .trim(from: 0, to: 0.5)
                                    .rotation(Angle(degrees: -120))
                            )
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(Angle(degrees: -90))
                            .stroke(themeManager.theme.border, lineWidth: 2)
                        
                    }
                )
        }
    }
    func cancelButton() -> some View {
        Button(action: {
            PopupManager.dismiss()
        }) {
            Image(systemName: "pencil.circle")
                .scaleEffect(1.2)
                .foregroundColor(themeManager.theme.text)
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(themeManager.theme.backgroundAccent)
                            .clipShape(
                                Rectangle()
                                    .scale(1.1)
                                    .trim(from: 0.125, to: 0.625)
                                    .rotation(Angle(degrees: 0))
                            )
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(Angle(degrees: 90))
                            .fill(themeManager.theme.backgroundAccent)
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.theme.border, lineWidth: 2)
                            .clipShape(
                                Rectangle()
                                    .scale(1.1)
                                    .trim(from: 0.125, to: 0.625)
                                    .rotation(Angle(degrees: 0))
                            )
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(Angle(degrees: 90))
                            .stroke(themeManager.theme.border, lineWidth: 2)
                    }
                )
        }
    }
}

struct TraceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TraceDetailPopup()
    }
}
