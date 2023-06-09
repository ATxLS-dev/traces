//
//  TraceTile.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import MapKit

struct TraceTile: View {
    
    var trace: Trace
    
    var body: some View {
        ZStack {
            Rectangle()
                .borderRadius(outlineColor, width: 2, cornerRadius: 25, corners: [.topLeft, .topRight, .bottomLeft])
                .foregroundColor(.clear)
                .background(snow)
            HStack {
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: trace.latitude, longitude: trace.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))), interactionModes: [])
                    .frame(width: 96, height: 96)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(outlineColor, lineWidth: 1)
                    )
                    .shadow(color: .gray, radius: 4)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                Divider()
                Spacer(minLength: 12)
                VStack(alignment: .trailing) {
                    Text(trace.username)
                        .font(.body)
                    Text((trace.creationDate)
//                        .formatted(
//                            .dateTime
//                                .day(.twoDigits)
//                                .month(.defaultDigits)
//                                .year(.twoDigits)
//                        )
                    )
                    Spacer()
                    Text(trace.locationName)
                        .multilineTextAlignment(.trailing)
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 20))
            }
            .frame(height: 140)
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}
