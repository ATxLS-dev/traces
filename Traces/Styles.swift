//
//  Styles.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI

let outlineColor: Color = .gray
let backgroundColor: Color = .green
let warmGray: Color = Color(hex: 0x494947)
let snow: Color = Color(hex: 0xF9F3F1)
let sweetGreen: Color = Color(hex: 0x4E7E63)
let skyBlue: Color = Color(hex: 0xADD6EB)
let raisinBlack: Color = Color(hex: 0x2D242C)

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

struct GreenButton: ButtonStyle {
    let width: CGFloat = 48
    
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "checkmark")
            .frame(width: width, height: width)
            .foregroundColor(snow)
            .background(sweetGreen)
            .clipShape(Circle())
            .font(.system(size: width / 2))
            .overlay(
                Circle()
                    .stroke(snow, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension UIToolbar {
    static func changeAppearance(clear: Bool) {
        let appearance = UIToolbarAppearance()
        
        if clear {
            appearance.configureWithOpaqueBackground()
        } else {
            appearance.configureWithDefaultBackground()
        }
        
        // customize appearance for your needs here
        appearance.shadowColor = .clear
        appearance.backgroundColor = .clear
        appearance.backgroundImage = UIImage(named: "imageName")
        
        UIToolbar.appearance().standardAppearance = appearance
        UIToolbar.appearance().compactAppearance = appearance
        UIToolbar.appearance().scrollEdgeAppearance = appearance
    }
}
