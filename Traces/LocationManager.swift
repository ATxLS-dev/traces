//
//  LocationManager.swift
//  Traces
//
//  Created by Bryce on 6/17/23.
//

import Foundation
import SwiftUI
import MapKit

class LocationManager: ObservableObject {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
//            enableLocationFeatures()
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
//            disableLocationFeatures()
            break
            
        case .notDetermined:        // Authorization not determined yet.
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }

}
