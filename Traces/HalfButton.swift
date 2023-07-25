//
//  HalfButton.swift
//  Traces
//
//  Created by Bryce on 7/22/23.
//

import SwiftUI

public struct HalfButton: View {

    @ObservedObject var themeManager: ThemeManager = ThemeManager.shared
    
    var icon: String = "line.3.horizontal.decrease.circle"
    var size: CGFloat = 48
    var widthScale: CGFloat = 1.0
    
    public var body: some View {
        ZStack {
            Rectangle()
                .fill(themeManager.theme.button)
                .cornerRadius(size / 4, corners: [.topLeft, .bottomLeft])
                .cornerRadius(size / 2, corners: [.topRight, .bottomRight])
            Rectangle()
                .fill(themeManager.theme.background)
                .cornerRadius(size / 4 - 1, corners: [.topLeft, .bottomLeft])
                .cornerRadius(size / 2, corners: [.topRight, .bottomRight])
                .scaleEffect(0.92)
            Image(systemName: icon)
                .scaleEffect(1.2)
                .foregroundColor(themeManager.theme.text)
        }
        .frame(width: size, height: size)
    }
}
