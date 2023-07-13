//
//  LocationManager.swift
//  Traces
//
//  Created by Bryce on 6/17/23.
//

import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.789467, longitude: -122.416772)
    
    private override init() {
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
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
    
    func updateUserLocation() {
        locationManager.requestLocation()
    }

}
