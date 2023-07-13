//
//  LocationManager.swift
//  Traces
//
//  Created by Bryce on 6/17/23.
//

import CoreLocation
import Combine


class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() async {
        Task {
            if CLLocationManager.locationServicesEnabled() {
                switch locationManager.authorizationStatus {
                case .restricted, .denied:
                    print("Location permission denied")
                default:
                    locationManager.requestWhenInUseAuthorization()
                }
            } else {
                print("Location services are not enabled")
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
    }
}
