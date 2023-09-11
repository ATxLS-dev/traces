//
//  BorderedRectangle.swift
//  Traces
//
//  Created by Bryce on 7/26/23.
//

import SwiftUI

struct BorderedRectangle: View {
    @EnvironmentObject var theme: ThemeController
    
    var hasColoredBorder: Bool = false
    var cornerRadius: CGFloat = 32
    var accented: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(accented ? theme.backgroundAccent : theme.background)
            RoundedRectangle(cornerRadius: cornerRadius + 1)
                .strokeBorder(hasColoredBorder ? theme.accent : theme.border, lineWidth: 2)
        }
    }
}

