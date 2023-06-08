//
//  ColorTheme.swift
//  Traces
//
//  Created by Bryce on 5/29/23.
//

import SwiftUI

extension Color {
    static let light = LightTheme()
    static let dark = DarkTheme()
}

protocol AppTheme {
    var accent: Color { get }
    var background: Color { get }
    var primaryText: Color { get }
}

struct LightTheme: AppTheme {
    let accent = sweetGreen
    let background = snow
    let primaryText = raisinBlack
}

struct DarkTheme: AppTheme {
    let accent = sweetGreen
    let background = raisinBlack
    let primaryText = snow
}
