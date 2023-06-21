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
    
    func createContent() -> some View {
        VStack {
            createMap()
            createPrompt()
            createEditButton()
            createSubmitButton()
        }
        .padding(10)
        .frame(height: 600)
        .background(snow)
    }
}

extension TraceDetailView {
    func createMap() -> some View {
        MapBox(center: region)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    func createPrompt() -> some View {
        Text(trace?.locationName ?? "Location Name")
            .font(.title)
    }
    func createField() -> some View {
        TextField("User", text: $username)
            .textFieldStyle(.roundedBorder)
    }
    func createEditButton() -> some View {
        Text(trace?.content ?? "Description")
    }
    
    func createSubmitButton() -> some View {
        HStack {
            Button(action: PopupManager.dismiss) {
                let width: CGFloat = 48
                Image(systemName: "ellipsis")
                    .frame(width: width * 3, height: width)
                    .foregroundColor(snow)
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .font(.system(size: width / 2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(snow, lineWidth: 1)
                    )
                    .shadow(color: .gray, radius: 4, x: 2, y: 2)
            }
            Spacer()
            Button(action: {
                PopupManager.dismiss();
            }) {
                let width: CGFloat = 48
                Image(systemName: "checkmark")
                    .frame(width: width * 3, height: width)
                    .foregroundColor(snow)
                    .background(themeManager.theme.text)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .font(.system(size: width / 2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.theme.background, lineWidth: 1)
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
