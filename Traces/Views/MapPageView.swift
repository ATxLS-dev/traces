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
    
    @ObservedObject var locationController = LocationController.shared
    @ObservedObject var themeController = ThemeController.shared
    
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
                    locationController.snapshotLocation()
                }) {
                    ZStack {
                        Circle()
                            .fill(themeController.theme.background)
                            .frame(width: buttonDimen, height: buttonDimen)
                        Circle()
                            .stroke(themeController.theme.buttonBorder, lineWidth: 2)
                            .frame(width: buttonDimen, height: buttonDimen)
                        Image(systemName: "location")
                            .foregroundColor(themeController.theme.text)
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
