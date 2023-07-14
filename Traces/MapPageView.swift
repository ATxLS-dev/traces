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
    
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var themeManager = ThemeManager.shared
    
    private let buttonDimen: CGFloat = 55
    
    var body: some View {
        ZStack {
            MapBox(mapType: .interactive)
                .onAppear {
                    Task {
                        await locationManager.checkLocationAuthorization()
                        print(locationManager.userLocation)
                    }
                }
            userLocatorButton()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func userLocatorButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    locationManager.updateUserLocation()
                }) {
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
