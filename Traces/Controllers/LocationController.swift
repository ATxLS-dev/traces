//
//  LocationManager.swift
//  Traces
//
//  Created by Bryce on 6/17/23.
//

import CoreLocation
import Combine

@MainActor
class LocationController: NSObject, CLLocationManagerDelegate, ObservableObject {

    private let locationManager = CLLocationManager()
    var lastLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.789467, longitude: -122.416772)
    @Published var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.789467, longitude: -122.416772)
    @Published var shouldRecenter: Bool = true
    
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    nonisolated func checkLocationAuthorization() async {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .restricted, .denied:
                print("Location permission denied")
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                break
            }
        } else {
            print("Location services are not enabled")
            
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { [self] in
            authorizationStatus = manager.authorizationStatus
        }
    }

    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async { [self] in
            userLocation = location.coordinate
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
    
    func snapshotLocation() {
        locationManager.requestLocation()
        lastLocation = userLocation
        shouldRecenter = true
    }
    
    func toggleRecenter() {
        shouldRecenter.toggle()
    }
}
