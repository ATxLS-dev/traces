//
//  TraceTile.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import MapKit

struct TraceTileTall: View {
    
    var trace: Trace
    
    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: trace.latitude, longitude: trace.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
                interactionModes: [])
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .frame(height: 240)
            Spacer()
            Text(trace.locationName ?? "---")
            Spacer()
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .background(
            Rectangle()
                .borderRadius(outlineColor, width: 0, cornerRadius: 20, corners: [.topLeft, .topRight, .bottomLeft])
                .foregroundColor(.white)
                .padding(2)
                .shadow(color: .gray, radius: 1)
        )
        .frame(width: 240, height: 320)

    }
}

extension TraceTileTall {
    func buildTracePin(location: String) -> some View {
        VStack {
            Image(systemName: "pin.circle.fill").foregroundColor(sweetGreen)
            Text(location)
        }
    }
}

