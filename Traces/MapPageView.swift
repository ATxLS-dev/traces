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
            MapBox(isInteractive: true)
            userLocatorButton()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func userLocatorButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    locationManager.snapshotLocation()
                }) {
                    ZStack {
                        Circle()
                            .fill(themeManager.theme.backgroundAccent)
                            .frame(width: buttonDimen, height: buttonDimen)
                        Circle()
                            .stroke(themeManager.theme.accent, lineWidth: 2)
                            .frame(width: buttonDimen, height: buttonDimen)
                        Image(systemName: "location")
                            .foregroundColor(themeManager.theme.text)
                            .padding()
                    }
                    .padding()
                }
            }
        }
        .padding(.bottom, 120)
    }
}

struct MapPageView_Previews: PreviewProvider {
    static var previews: some View {
        MapPageView()
    }
}
