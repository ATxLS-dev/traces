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


struct TraceDetailView: CentrePopup {
    
    func configurePopup(popup: CentrePopupConfig) -> CentrePopupConfig {
        popup.horizontalPadding(10);
    }
    
    var trace: Trace?
    
    @State private var username: String = ""
    @State private var content: String = ""
    @State var region = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889)
    @ObservedObject var themeManager = ThemeManager.shared
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    init(trace: Trace? = nil) {
        if let trace = trace {
            self.region = CLLocationCoordinate2D(latitude: trace.latitude, longitude: trace.longitude)
        }
    }
    
    func createContent() -> some View {
        VStack {
            HStack {
                createMap()
                Spacer()
                createPrompt()
            }
            .frame(height: 180)
            Spacer()
            createDescription()
            Spacer()
            createSubmitButton()
        }
        .padding(16)
        .frame(height: 480)
        .background(themeManager.theme.background)
    }
}

extension TraceDetailView {
    func createMap() -> some View {
        MapBox(center: region)
            .frame(width: 160, height: 160)
            .cornerRadius(24)
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(themeManager.theme.text)
            )
  
    }
    func createPrompt() -> some View {

        VStack {
            HStack {
                Spacer()
                Text(Date().formatted())
                    .font(.caption)
            }
            Spacer()
            Text(trace?.locationName ?? "Location Name")
                .font(.title)
            Spacer()
        }
        .foregroundColor(themeManager.theme.text)

    }
    
    func createDescription() -> some View {
        Text(trace?.content ?? "Description")
            .foregroundColor(themeManager.theme.text)

    }
    
    func createSubmitButton() -> some View {
        HStack {
            Button(action: PopupManager.dismiss) {
                let width: CGFloat = 48
                Image(systemName: "ellipsis")
                    .frame(width: width * 3, height: width)
                    .foregroundColor(themeManager.theme.text)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.theme.accent)
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(themeManager.theme.text, lineWidth: 2)
                        }
                    )
            }
            Spacer()
            Button(action: {
                PopupManager.dismiss();
            }) {
                let width: CGFloat = 48
                Image(systemName: "checkmark")
                    .frame(width: width * 3, height: width)
                    .foregroundColor(themeManager.theme.text)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.theme.button)
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(themeManager.theme.text, lineWidth: 2)
                        }
                    )
            }
        }
    }
}

struct TraceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TraceDetailView()
    }
}
