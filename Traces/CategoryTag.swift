//
//  CategoryTag.swift
//  Traces
//
//  Created by Bryce on 6/15/23.
//

import SwiftUI

struct CategoryTag: View {
    
    let category: String
    @ObservedObject var supabaseManager = SupabaseManager.shared
    @ObservedObject var themeManager = ThemeManager.shared
    
    var body: some View {
        Button(action: {
            withAnimation {
                supabaseManager.toggleFilter(category: category)
            }}) {
            HStack(spacing: 12) {
                Text(category)
                    .font(.caption)
                Image(systemName: "x.circle")
                    .foregroundColor(themeManager.theme.accent.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    Capsule()
                        .fill(themeManager.theme.background)
                    Capsule()
                        .stroke(themeManager.theme.accent, lineWidth: 1.4)
                }
            )
            .foregroundColor(themeManager.theme.text)
        }.padding(2)
    }
}

struct CategoryTag_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTag(category: "Adventure")
    }
}
