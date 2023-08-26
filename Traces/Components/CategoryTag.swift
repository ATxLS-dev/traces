//
//  CategoryTag.swift
//  Traces
//
//  Created by Bryce on 6/15/23.
//

import SwiftUI

struct CategoryTag: View {
    
    let category: String
    @ObservedObject var supabaseController = SupabaseController.shared
    @ObservedObject var themeController = ThemeController.shared
    
    var body: some View {
        Button(action: {
            withAnimation {
                supabaseController.toggleFilter(category: category)
            }}) {
            HStack(spacing: 12) {
                Text(category)
                    .font(.caption)
                Image(systemName: "x.circle")
                    .foregroundColor(themeController.theme.accent.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    Capsule()
                        .fill(themeController.theme.background)
                    Capsule()
                        .stroke(themeController.theme.accent, lineWidth: 1.4)
                }
            )
            .foregroundColor(themeController.theme.text)
        }.padding(2)
    }
}

struct CategoryTag_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTag(category: "Adventure")
    }
}
