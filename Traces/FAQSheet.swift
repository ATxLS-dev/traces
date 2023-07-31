//
//  FAQSheet.swift
//  Traces
//
//  Created by Bryce on 7/9/23.
//

import SwiftUI

struct FAQSheet: View {
    
    @Binding var isPresented: Bool
    @ObservedObject var themeManager = ThemeManager.shared

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            buildQuestion(q: "How does the home page work?", a: "The traces you see there are sorted by proximity, you'll see what everyone else has marked around you.")
            buildQuestion(q: "What is this app?", a: "This is a tool for marking locations, whether for your own future reference or to share with friends!")
            Spacer()
        }
        .onTapGesture {
            isPresented = false
        }
        .padding()
        .background(themeManager.theme.background)
    }
    
    func buildQuestion(q question: String, a answer: String) -> some View {
        VStack(spacing: 16) {
            Text("Q: \(question)")
                .multilineTextAlignment(.center)
                .font(.title3)
                .fontWeight(.semibold)
            Text("A: \(answer)")
                .multilineTextAlignment(.center)
                .font(.body)
        }
        .padding()
        .foregroundColor(themeManager.theme.text)
    }
}
