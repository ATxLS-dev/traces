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
                    .fill(themeManager.theme.background)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(themeManager.theme.text, lineWidth: 2)
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
            .cornerRadius(12)
    }
    func createPrompt() -> some View {
        Text("Leave a trace?")
            .foregroundColor(themeManager.theme.text)
    }
    func createField() -> some View {
        TextField("Title", text: $title)
            .textFieldStyle(.plain)
            .padding(12)
            .background(
                ZStack {
                    Capsule()
                        .fill(themeManager.theme.accent)
                    Capsule()
                        .stroke(themeManager.theme.text, lineWidth: 2)
                }
            )
    }
    func createEditor() -> some View {
        TextEditor(text: $content)
            .foregroundColor(.black)
            .cornerRadius(24)
            .padding()
            .frame(height: 150)
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
                                .stroke(themeManager.theme.text, lineWidth: 1.4)
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
                                .stroke(themeManager.theme.text, lineWidth: 1.4)
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
