//
//  CircularProgressView.swift
//  Traces
//
//  Created by Bryce on 6/10/23.
//
//
import SwiftUI

struct CircularProgressView: View {
    
    let progress: Double = 0.0
    @EnvironmentObject var theme: ThemeController

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    theme.accent.opacity(0.5),
                    lineWidth: 30)
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(
                    theme.background, style: StrokeStyle(
                    lineWidth: 24,
                    lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}
