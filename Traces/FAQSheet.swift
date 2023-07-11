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
            buildQuestion(q: "What is this app?", a: "This is a tool for marking locations, whether for your own future reference or to share with friends!")
            buildQuestion(q: "What is Charlie's favorite food?", a: "Bacon")
            Spacer()
        }
        .padding()
        .background(themeManager.theme.background)
    }
    
    func buildQuestion(q question: String, a answer: String) -> some View {
        VStack(spacing: 16) {
            Text("Q: \(question)")
                .font(.title3)
                .fontWeight(.semibold)
            Text("A: \(answer)")
                .font(.body)
        }
        .padding()
        .foregroundColor(themeManager.theme.text)
    }
}
