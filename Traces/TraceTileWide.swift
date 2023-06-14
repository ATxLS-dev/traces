//
//  TraceTile.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import MapKit

struct TraceTileWide: View {
    
    var trace: Trace
    
    var body: some View {
        HStack {
            MapBoxView(center: CLLocationCoordinate2D(latitude: trace.latitude, longitude: trace.longitude))
            .clipShape(RoundedRectangle(cornerRadius: 9))
            .frame(width: 144, height: 144)
            .padding(6)
            .background(
                RoundedBorderRectangle()
            )
            Spacer()
            VStack {
                Spacer()
                Text(trace.locationName)
                    .foregroundColor(.black)
                Spacer()
                HStack {
                    Spacer()
                    Text(trace.username)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
        }
        .padding(8)
    }
}

extension TraceTileWide {
    func buildTracePin(location: String) -> some View {
        VStack {
            Image(systemName: "pin.circle.fill").foregroundColor(sweetGreen)
            Text(location)
        }
    }
}

