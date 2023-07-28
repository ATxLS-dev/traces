//
//  FilterPopup.swift
//  Traces
//
//  Created by Bryce on 6/12/23.
//

import SwiftUI
import Supabase

struct FilterDropdown: View {
    
    @ObservedObject var supabase = SupabaseManager.shared
    @ObservedObject var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(supabase.categories) { category in
                        let occurances = supabase.countCategoryOccurances(category)
                        if occurances != 0 {
                            buildActiveFilter(category: category, occurances: occurances)
                        } else {
                            buildInactiveFilter(category: category)
                        }
                    }
                }
            }
            .frame(height: 480)
            .padding(12)
            .background(
                ZStack {
                    BorderedRectangle(cornerRadius: 24)
                        .shadow(color: themeManager.theme.shadow, radius: 6, x: 2, y: 2)
                }
            )
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
    
    func buildActiveFilter(category: Category, occurances: Int) -> some View {
        Button(action: {
            withAnimation { () -> () in
                supabase.toggleFilter(category: category.name)
            }
        }) {
            HStack {
                Text(category.name)
                    .font(.body)
                    .foregroundColor(themeManager.theme.text)
                    .padding(4)
                Spacer()
                Text(String(occurances))
                    .foregroundColor(themeManager.theme.text.opacity(0.6))
                    .font(.caption)
                    .padding(.horizontal)
                    .background(
                        BorderedCapsule(hasThinBorder: true)
                            .frame(width: 22, height: 22))
                if supabase.filters.contains(category.name) {
                    Image(systemName: "checkmark")
                        .foregroundColor(themeManager.theme.accent)
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
                .foregroundColor(themeManager.theme.text.opacity(0.4))
                .padding(4)
            Spacer()
            if supabase.filters.contains(category.name) {
                Image(systemName: "checkmark")
                    .foregroundColor(themeManager.theme.accent)
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
