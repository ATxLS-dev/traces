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
    var userID: UUID
    var creationDate: String
    var latitude: Double
    var longitude: Double
    var locationName: String
    var content: String
    var categories: [String]

    func buildPopup() {}
    
    enum CodingKeys: String, CodingKey {
        case id = "trace_id"
        case userID = "user_id"
        case creationDate = "creation_date"
        case latitude = "latitude"
        case longitude = "longitude"
        case locationName = "location_name"
        case content = "content"
        case categories = "categories"
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

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
