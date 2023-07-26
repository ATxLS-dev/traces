//
//  BorderedRectangle.swift
//  Traces
//
//  Created by Bryce on 7/26/23.
//

import SwiftUI

struct BorderedRectangle: View {
    @ObservedObject var themeManager: ThemeManager = ThemeManager.shared
    
    var hasColoredBorder: Bool = false
    var cornerRadius: CGFloat = 32
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(themeManager.theme.backgroundAccent)
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(hasColoredBorder ? themeManager.theme.accent : themeManager.theme.border, lineWidth: 2)
        }
    }
}

struct BorderedRectangle_Previews: PreviewProvider {
    static var previews: some View {
        BorderedRectangle()
    }
}
