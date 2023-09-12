//
//  CategoryTag.swift
//  Traces
//
//  Created by Bryce on 6/15/23.
//

import SwiftUI

struct CategoryTag: View {
    
    let category: String
    @EnvironmentObject var feed: FeedController
    @EnvironmentObject var theme: ThemeController
    
    var body: some View {
        Button(action: {
            withAnimation {
                feed.toggleFilter(category: category)
            }}) {
            HStack(spacing: 12) {
                Text(category)
                    .font(.caption)
                Image(systemName: "x.circle")
                    .foregroundColor(theme.accent.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    Capsule()
                        .fill(theme.background)
                    Capsule()
                        .stroke(theme.accent, lineWidth: 1.4)
                }
            )
            .foregroundColor(theme.text)
        }.padding(2)
    }
}
