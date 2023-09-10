//
//  ReactionSlider.swift
//  Traces
//
//  Created by Bryce on 9/3/23.
//

import SwiftUI

struct ReactionSlider: View {
    @StateObject var themeController = ThemeController.shared
    @State var averageReaction: CGFloat
    
    var body: some View {
        HStack {
            Slider(value: $averageReaction, in: 0...10, step: 1)
                .tint(rainbowGradient)
                .foregroundStyle(themeController.theme.buttonBackground)
            Text("\(Int(averageReaction))")
        }
    }
    
    var rainbowGradient: Gradient = Gradient(colors: [.red,.orange,.yellow,.green,.blue])
}

#Preview("Reaction Slider") {
    ReactionSlider(averageReaction: 4.0)
}
