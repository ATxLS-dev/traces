//
//  BorderedCapsule.swift
//  Traces
//
//  Created by Bryce on 7/22/23.
//

import SwiftUI

struct BorderedCapsule: View {
    
    @ObservedObject var themeController: ThemeController = ThemeController.shared
    
    var hasColoredBorder: Bool = false
    var hasThinBorder: Bool = false
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(themeController.theme.backgroundAccent)
            Capsule()
                .stroke(hasColoredBorder ? themeController.theme.buttonBorder : themeController.theme.border, lineWidth: hasThinBorder ? 1.4 : 2)
        }
    }
}

struct BorderedCapsule_Previews: PreviewProvider {
    static var previews: some View {
        BorderedCapsule()
    }
}
