//
//  FieldLabel.swift
//  Traces
//
//  Created by Bryce on 7/22/23.
//

import SwiftUI

struct FieldLabel: View {
    
    let fieldLabel: String
    @ObservedObject var themeController: ThemeController = ThemeController.shared
    
    var body: some View {
        Text(fieldLabel)
            .foregroundColor(themeController.theme.text.opacity(0.6))
            .font(.subheadline)
            .padding(.horizontal)
//            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [themeController.theme.background, themeController.theme.backgroundAccent]),
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
