//
//  FilterPopup.swift
//  Traces
//
//  Created by Bryce on 6/12/23.
//

import SwiftUI
import Supabase

struct FilterDropdown: View {
    
    @ObservedObject var supabaseManager = SupabaseManager.shared
    @ObservedObject var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(supabaseManager.categories) { category in
                        Button(action: {
                            withAnimation { () -> () in
                                supabaseManager.toggleFilter(category: category.category)
                            }
                        }) {
                            HStack {
                                Text(category.category)
                                    .font(.body)
                                    .foregroundColor(themeManager.theme.text)
                                    .padding(4)
                                Spacer()
                                if supabaseManager.filters.contains(category.category) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(themeManager.theme.accent)
                                        .padding(.trailing, 6)
                                }
                            }
                            .frame(width: 220)
                        }
                    }
                }
            }
            .frame(height: 480)
            .padding(12)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24).foregroundColor(themeManager.theme.backgroundAccent)
                    RoundedRectangle(cornerRadius: 24).stroke(themeManager.theme.border, lineWidth: 2)
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
}


struct FilterDropdown_Previews: PreviewProvider {
    static var previews: some View {
        FilterDropdown()
    }
}
