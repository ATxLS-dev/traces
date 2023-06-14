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

protocol InteractiveTrace: Codable, Identifiable, Equatable {
    var id: UUID { get }
    var creationDate: Date { get }
    var username: String { get }
    var locationName: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var content: String { get }
    func buildPopup()
}

extension InteractiveTrace {
    static func buildPopup() -> some View {
        TraceDetailView()
    }
}

struct Trace: Codable, Identifiable, Equatable {
    var id: UUID
    var creationDate: String
    var username: String
    var locationName: String
    var latitude: Double
    var longitude: Double
    var content: String
    var category: String
    func buildPopup() {}
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case creationDate = "creation_date"
        case username = "username"
        case locationName = "location_name"
        case latitude = "latitude"
        case longitude = "longitude"
        case content = "content"
        case category = "category"
        
        var stringValue: String {
            return rawValue
        }
    }
}
