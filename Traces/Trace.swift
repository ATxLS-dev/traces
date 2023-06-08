//
//  Trace.swift
//  Traces
//
//  Created by Bryce on 6/6/23.
//

import SwiftUI
import CoreData
import MapKit
import PopupView

protocol InteractiveTrace: Identifiable {
    var latitude: Double { get }
    var longitude: Double { get }
    var username: String { get }
    var locationName: String { get }
    var content: String { get }
    var creationDate: Date { get }
    var id: UUID { get }
    func buildPopup()
}

extension InteractiveTrace {
    static func buildPopup() -> some View {
        TraceDetailView()
    }
}
