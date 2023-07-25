//
//  Themeinator.swift
//  Traces
//
//  Created by Bryce on 6/18/23.
//

import Foundation
import SwiftUI

let warmGray: Color = Color(hex: 0x494947)

let skyBlue: Color = Color(hex: 0xADD6EB)
let raisinBlack: Color = Color(hex: 0x2D242C)
let flame: Color = Color(hex: 0xCF5C36)
let verdigris: Color = Color(hex: 0x50A2A7)
let chocolateCosmos: Color = Color(hex: 0x5A2328)
let persianGreen: Color = Color(hex: 0x1B998B)
let bittersweetShimmer: Color = Color(hex: 0xBC4B51)
let brunswickGreen: Color = Color(hex: 0x034C3C)

let coolGray: Color = Color(hex: 0x8D89A6)
let burntSienna: Color = Color(hex: 0xE76F51)
let darkSienna: Color = Color(hex: 0xC97D60)
let tropicalIndigo: Color = Color(hex: 0x8E7DBE)
let aero: Color = Color(hex: 0x42BFDD)
let taupeGray: Color = Color(hex: 0x847577)



//BASE COLORS

let snow: Color = Color(hex: 0xF9F3F1)
let ash: Color = Color(hex: 0xA4B9AA)
let veridian: Color = Color(hex: 0x4E7E63)
let licorice: Color = Color(hex: 0x171216)
let night: Color = Color(hex: 0x121717)


//MAYBE

let eggplant: Color = Color(hex: 0x714955)
let brownSugar: Color = Color(hex: 0xB4654A)
let wine: Color = Color(hex: 0x6A2E35)
let poppy: Color = Color(hex: 0xD64045)
let liver: Color = Color(hex: 0x664E4C)
let spaceCadet: Color = Color(hex: 0x664E4C)
let chestnut: Color = Color(hex: 0xA53F2B)


let rainbowColors: [Color] = [
    Color(hex: 0xFF0000),    // Red
    Color(hex: 0xFF7F00),    // Orange
    Color(hex: 0xFFFF00),    // Yellow
    Color(hex: 0x00FF00),    // Green
    Color(hex: 0x0000FF),    // Blue
    Color(hex: 0x4B0082),    // Indigo
    Color(hex: 0x9400D3),    // Violet
    Color(hex: 0x800000),    // Maroon
    Color(hex: 0xFF4500),    // Orange-Red
    Color(hex: 0xFFD700),    // Gold
    Color(hex: 0x00FFFF)     // Cyan
]

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension Color {
    static func random() -> Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}


class ThemeManager: ObservableObject {
    
    static let shared = ThemeManager()
    
    @Published var theme: ColorTheme
    
    var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "darkMode")
    
    private init() {
        self.theme = isDarkMode ? light : dark
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
        UserDefaults.standard.set(isDarkMode, forKey: "darkMode")
        self.theme = isDarkMode ? light : dark
    }
}

let light: ColorTheme = LightTheme()
let dark: ColorTheme = DarkTheme()

protocol ColorTheme {
    var backgroundAccent: Color { get }
    var border: Color { get }
    var background: Color { get }
    var accent: Color { get }
    var text: Color { get }
    var button: Color { get }
    var mapStyle: String { get }
}

struct LightTheme: ColorTheme {
    var backgroundAccent: Color = .white
    var border: Color = .black
    var background: Color = snow
    var accent: Color = veridian
    var text: Color = licorice
    var button: Color = ash
    var mapStyle: String = "mapbox://styles/atxls/cliuqmp8400kv01pw57wxga7l"
}

struct DarkTheme: ColorTheme {
    var backgroundAccent: Color = .black
    var border: Color = taupeGray
    var background: Color = night
    var accent: Color = veridian
    var text: Color = snow
    var button: Color = veridian
    var mapStyle: String = "mapbox://styles/atxls/clj4rozom000401pw7na12c30"
}

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(ClearBackgroundView())
    }
}

extension View {
    func clearModalBackground()->some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
