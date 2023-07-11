//
//  MapView.swift
//  GeoTag
//
//  Created by Bryce on 5/11/23.
//
import SwiftUI
import MapKit
import CoreLocation

struct MapPageView: View {
    @StateObject var locationManager = LocationManager()
    let defaultLocation = CLLocationCoordinate2D(latitude: 37.789467, longitude: -122.416772)
    
    var body: some View {
        MapBox(center: locationManager.userLocation, interactable: true)
            .offset(y: -12.5)
            .onAppear {
                locationManager.checkLocationAuthorization()
            }
    }
}

struct MapPageView_Previews: PreviewProvider {
    static var previews: some View {
        MapPageView()
    }
}
