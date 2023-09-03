//
//  FilterPopup.swift
//  Traces
//
//  Created by Bryce on 6/12/23.
//

import SwiftUI
import Supabase

struct FilterDropdown: View {
    
    @ObservedObject var supabase = SupabaseController.shared
    @ObservedObject var themeController = ThemeController.shared
    
    var body: some View {
        ZStack {
            BorderedRectangle(cornerRadius: 24)
                .shadow(color: themeController.theme.shadow, radius: 6, x: 2, y: 2)
                .frame(width: 260, height: 500)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(supabase.categories) { category in
                        let occurences = supabase.countCategoryOccurences(category)
                        if occurences != 0 {
                            buildActiveFilter(category: category, occurences: occurences)
                        } else {
                            buildInactiveFilter(category: category)
                        }
                    }
                }
            }
            .frame(height: 480)
            .padding(12)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
    
    func buildActiveFilter(category: Category, occurences: Int) -> some View {
        Button(action: {
            withAnimation { () -> () in
                supabase.toggleFilter(category: category.name)
            }
        }) {
            HStack {
                Text(category.name)
                    .font(.body)
                    .foregroundColor(themeController.theme.text)
                    .padding(4)
                Spacer()
                ZStack {
                    BorderedCapsule(hasThinBorder: true)
                        .frame(width: 22, height: 22)
                    Text(String(occurences))
                        .foregroundColor(themeController.theme.text.opacity(0.6))
                        .font(.caption)
                }
                .padding(.horizontal, 6)

                if supabase.filters.contains(category.name) {
                    Image(systemName: "checkmark")
                        .foregroundColor(themeController.theme.accent)
                        .padding(.trailing, 6)
                }
            }
            .frame(width: 220)
        }
    }
    
    func buildInactiveFilter(category: Category) -> some View {
        HStack {
            Text(category.name)
                .font(.body)
                .foregroundColor(themeController.theme.text.opacity(0.4))
                .padding(4)
            Spacer()
            if supabase.filters.contains(category.name) {
                Image(systemName: "checkmark")
                    .foregroundColor(themeController.theme.accent)
                    .padding(.trailing, 6)
            }
        }
        .frame(width: 220)
    }
}


struct FilterDropdown_Previews: PreviewProvider {
    static var previews: some View {
        FilterDropdown()
    }
}
