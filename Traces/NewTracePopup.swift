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
    
    @State private var username: String = ""
    @State private var content: String = ""
    @State var region = MKCoordinateRegion(center: .init(latitude: 37.334722, longitude: -122.008889), latitudinalMeters: 300, longitudinalMeters: 300)
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext

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
        .background(snow)
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
        Map(coordinateRegion: $region, interactionModes: [])
            .frame(height: 128)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(warmGray, lineWidth: 1))
    }
    func createPrompt() -> some View {
        Text("Leave a trace?")
    }
    func createField() -> some View {
        TextField("User", text: $username)
            .textFieldStyle(.roundedBorder)
    }
    func createEditor() -> some View {
        TextEditor(text: $content)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.black, lineWidth: 1 / 3)
                    .opacity(0.3)
            )
            .font(.body)
    }
    func createSubmitButton() -> some View {
        HStack {
            Button(action: PopupManager.dismiss) {
                let width: CGFloat = 48
                Image(systemName: "xmark")
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
//                addEntry(username: username, content: content);
                PopupManager.dismiss();
            }) {
                let width: CGFloat = 48
                Image(systemName: "checkmark")
                    .frame(width: width * 3, height: width)
                    .foregroundColor(snow)
                    .background(sweetGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .font(.system(size: width / 2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(snow, lineWidth: 1)
                    )
                    .shadow(color: .gray, radius: 4, x: 2, y: 2)
            }
        }
    }
}

struct TracePopup_Previews: PreviewProvider {
    static var previews: some View {
        NewTracePopup()
    }
}
