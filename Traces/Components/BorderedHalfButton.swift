//
//  HalfButton.swift
//  Traces
//
//  Created by Bryce on 7/22/23.
//

import SwiftUI

public struct BorderedHalfButton: View {

    @EnvironmentObject var theme: ThemeController
    
    var icon: String = "line.3.horizontal.decrease.circle"
    var size: CGFloat = 48
    var widthScale: CGFloat = 1.0
    var noBorderColor: Bool = false
    var noBackgroundColor: Bool = false
    
    public var body: some View {
        ZStack {
            Rectangle()
                .fill(noBorderColor ? theme.border : theme.button)
                .cornerRadius(size / 4, corners: [.topLeft, .bottomLeft])
                .cornerRadius(size / 2, corners: [.topRight, .bottomRight])
            Rectangle()
                .fill(noBackgroundColor ? theme.backgroundAccent : theme.buttonBackground)
                .cornerRadius(size / 4 - 1, corners: [.topLeft, .bottomLeft])
                .cornerRadius(size / 2, corners: [.topRight, .bottomRight])
                .scaleEffect(0.92)
            Image(systemName: icon)
                .scaleEffect(1.2)
                .foregroundColor(theme.text)
        }
        .frame(width: size, height: size)
    }
}
