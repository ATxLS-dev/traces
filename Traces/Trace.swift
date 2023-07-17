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

struct Trace: Codable, Identifiable, Equatable {
    var id: UUID
    var creationDate: String
    var username: String
    var locationName: String
    var latitude: Double
    var longitude: Double
    var content: String
    var category: String
    var user_id: UUID
    func buildPopup() {}
    
    enum CodingKeys: String, CodingKey {
        case id = "post_id"
        case creationDate = "creation_date"
        case username = "username"
        case locationName = "location_name"
        case latitude = "latitude"
        case longitude = "longitude"
        case content = "content"
        case category = "category"
        case user_id = "user_id"
        
        var stringValue: String {
            return rawValue
        }
    }
}

struct Category: Codable, Identifiable, Equatable {
    
    var id: UUID
    var category: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case category = "category"
        
        var stringValue: String {
            return rawValue
        }
    }
    
}
