//
//  FieldLabel.swift
//  Traces
//
//  Created by Bryce on 7/22/23.
//

import SwiftUI

struct FieldLabel: View {
    
    let fieldLabel: String
    @ObservedObject var themeManager: ThemeManager = ThemeManager.shared
    
    var body: some View {
        Text(fieldLabel)
            .foregroundColor(themeManager.theme.text.opacity(0.6))
            .font(.subheadline)
            .padding(.horizontal)
//            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [themeManager.theme.background, themeManager.theme.backgroundAccent]),
                            startPoint: UnitPoint(x: 0, y: 0.4),
                            endPoint: UnitPoint(x: 0, y: 0.6)
                        )
                    )
            )
    }
}

struct FieldLabel_Previews: PreviewProvider {
    static var previews: some View {
        FieldLabel(fieldLabel: "Test text")
    }
}
