//
//  TraceTile.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import MapKit

struct TraceTile: View {
    
    @ObservedObject var themeManager = ThemeManager.shared
    var trace: Trace
    
    var body: some View {
        HStack {
            MapBox(center: CLLocationCoordinate2D(latitude: trace.latitude, longitude: trace.longitude))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(width: 144, height: 144)
            .padding(4)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(themeManager.theme.text, lineWidth: 4)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(themeManager.theme.background)
                }
            )
            Spacer()
            VStack {
                Spacer()
                Text(trace.locationName)
                    .foregroundColor(themeManager.theme.text)
                Spacer()
                HStack {
                    Spacer()
                    Text(trace.username)
                        .foregroundColor(themeManager.theme.text.opacity(0.4))
                        .font(.caption)
                }
            }
        }
        .padding(8)
    }
}

extension TraceTile {
    func buildTracePin(location: String) -> some View {
        VStack {
            Image(systemName: "pin.circle.fill").foregroundColor(themeManager.theme.accent)
            Text(location)
        }
    }
}

