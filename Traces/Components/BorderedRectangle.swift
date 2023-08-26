//
//  BorderedRectangle.swift
//  Traces
//
//  Created by Bryce on 7/26/23.
//

import SwiftUI

struct BorderedRectangle: View {
    @ObservedObject var themeController: ThemeController = ThemeController.shared
    
    var hasColoredBorder: Bool = false
    var cornerRadius: CGFloat = 32
    var accented: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(accented ? themeController.theme.backgroundAccent : themeController.theme.background)
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(hasColoredBorder ? themeController.theme.accent : themeController.theme.border, lineWidth: 2)
        }
    }
}

struct BorderedRectangle_Previews: PreviewProvider {
    static var previews: some View {
        BorderedRectangle()
    }
}
