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
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: trace.latitude, longitude: trace.longitude), span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))),
                interactionModes: [])
                .clipShape(RoundedRectangle(cornerRadius: 12))
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
        .padding(12)
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

