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
    @ObservedObject var themeManager = ThemeManager.shared
    
    private let defaultLocation = CLLocationCoordinate2D(latitude: 37.789467, longitude: -122.416772)
    private let buttonDimen: CGFloat = 55
    
    var body: some View {
        ZStack {
            MapBox(center: locationManager.userLocation, interactable: true)
                .offset(y: -12.5)
                .onAppear {
                    Task {
                        await locationManager.checkLocationAuthorization()
                    }
                }
            userLocatorButton()
        }
    }
    
    func userLocatorButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(themeManager.theme.backgroundAccent)
                            .frame(width: buttonDimen, height: buttonDimen)
                        Circle()
                            .stroke(themeManager.theme.border, lineWidth: 2)
                            .frame(width: buttonDimen, height: buttonDimen)
                        Image(systemName: "location")
                            .foregroundColor(themeManager.theme.text)
                            .padding()
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .padding(.bottom, 100)
    }
}

struct MapPageView_Previews: PreviewProvider {
    static var previews: some View {
        MapPageView()
    }
}
