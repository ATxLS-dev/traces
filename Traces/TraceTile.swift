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
            MapBox(focalTrace: trace, interactable: false)
                .clipShape(RoundedRectangle(cornerRadius: 29))
                .frame(width: 144, height: 144)
                .padding(4)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(themeManager.theme.border, lineWidth: 4)
                        RoundedRectangle(cornerRadius: 32)
                            .fill(themeManager.theme.backgroundAccent)
                    }
                )
            Spacer()
            ZStack {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Spacer()
                        Text("@\(trace.username)")
                            .foregroundColor(themeManager.theme.text.opacity(0.6))
                            .font(.caption)
                        Text(getFormattedDate())
                            .foregroundColor(themeManager.theme.text.opacity(0.8))
                            .font(.caption2)
                    }
                    .padding(.vertical, 4)
                }
                
                Text(trace.locationName)
                    .foregroundColor(themeManager.theme.text)
            }
        }
        .padding(8)
    }
    
    private func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        
        guard let date = dateFormatter.date(from: trace.creationDate) else {
            return "date not found"
        }
        
        dateFormatter.dateFormat = "MM/d/yy, h:mm a"

        let result = dateFormatter.string(from: date)
        return result
    }
}
