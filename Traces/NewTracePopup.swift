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
        popup.horizontalPadding(10);
    }
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State var region = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889)
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var themeManager = ThemeManager.shared

    func createContent() -> some View {
        VStack {
            createMap()
            createPrompt()
            createField()
            createEditor()
            createSubmitButton()
        }
        .padding(12)
        .frame(height: 480)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(snow)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 2)
            }
        )
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
            .clipped()
            .cornerRadius(12)
    }
    func createPrompt() -> some View {
        Text("Leave a trace?")
    }
    func createField() -> some View {
        TextField("Title", text: $title)
            .textFieldStyle(.plain)
            .padding(8)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(themeManager.theme.background)
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(themeManager.theme.text, lineWidth: 1.4)
                        .opacity(1)
                }

            )
    }
    func createEditor() -> some View {
        TextEditor(text: $content)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(themeManager.theme.text, lineWidth: 1.4)
            )
            .font(.body)
    }
    func createSubmitButton() -> some View {
        HStack {
            Button(action: PopupManager.dismiss) {
                let width: CGFloat = 48
                Image(systemName: "xmark")
                    .frame(width: width, height: width)
                    .foregroundColor(themeManager.theme.text)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.black, lineWidth: 1.4)
                        }
                    )
            }
            Spacer()
            Button(action: PopupManager.dismiss) {
                let width: CGFloat = 48
                Image(systemName: "checkmark")
                    .frame(width: width * 3, height: width)
                    .foregroundColor(themeManager.theme.text)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.black, lineWidth: 1.4)
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.theme.button.opacity(0.4))
                        }
                    )
            }
        }
    }
}

struct NewTracePopup_Previews: PreviewProvider {
    static var previews: some View {
        NewTracePopup()
    }
}
