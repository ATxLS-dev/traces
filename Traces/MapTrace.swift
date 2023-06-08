//
//  MapTrace.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import UIKit
import MapKit

struct MapTrace: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var content: String = ""
    var datePosted: Date = Date.now
}

let MapTraces = [
    MapTrace(name: "St Francis Memorial Hospital", latitude: 37.789467, longitude: -122.416772, content: "Top-quality medical care"),
    MapTrace(name: "The Ritz-Carlton, San Francisco", latitude: 37.791965, longitude: -122.406903, content: "Luxurious hotel experience"),
    MapTrace(name: "Honey Honey Cafe & Crepery", latitude: 37.787891, longitude: -122.411223, content: "Delicious sweet and savory crepes"),
    MapTrace(name: "Golden Gate Bridge", latitude: 37.8199, longitude: -122.4783, content: "Iconic suspension bridge"),
    MapTrace(name: "Alcatraz Island", latitude: 37.8267, longitude: -122.4233, content: "Famous former prison island"),
    MapTrace(name: "Fisherman's Wharf", latitude: 37.8087, longitude: -122.4098, content: "Vibrant waterfront district"),
    MapTrace(name: "Chinatown, San Francisco", latitude: 37.7941, longitude: -122.4078, content: "Rich cultural heritage"),
    MapTrace(name: "Union Square, San Francisco", latitude: 37.7881, longitude: -122.4075, content: "Shopping and entertainment hub"),
    MapTrace(name: "Muir Woods National Monument", latitude: 37.8974, longitude: -122.5812, content: "Gorgeous coastal redwoods"),
    MapTrace(name: "Stanford University", latitude: 37.4275, longitude: -122.1697, content: "Renowned educational institution"),
    MapTrace(name: "Googleplex", latitude: 37.4219, longitude: -122.0841, content: "Google's headquarters"),
    MapTrace(name: "Facebook Headquarters", latitude: 37.4847, longitude: -122.1484, content: "Facebook's main campus"),
    MapTrace(name: "Apple Park", latitude: 37.3349, longitude: -122.0089, content: "Apple's futuristic campus"),
    MapTrace(name: "Oracle Arena", latitude: 37.7503, longitude: -122.2033, content: "Sports and entertainment venue"),
    MapTrace(name: "SAP Center", latitude: 37.3327, longitude: -121.9011, content: "Home of the Sharks"),
    MapTrace(name: "Levi's Stadium", latitude: 37.4030, longitude: -121.9700, content: "Home of the 49ers"),
    MapTrace(name: "Oakland Zoo", latitude: 37.7479, longitude: -122.1537, content: "Family-friendly wildlife experience"),
    MapTrace(name: "Great America", latitude: 37.3961, longitude: -121.9772, content: "Amusement park with thrill rides"),
    MapTrace(name: "California's Great America", latitude: 37.3985, longitude: -121.9748, content: "Exciting theme park adventures"),
    MapTrace(name: "Computer History Museum", latitude: 37.4140, longitude: -122.0764, content: "Exploring computing's past")
]
