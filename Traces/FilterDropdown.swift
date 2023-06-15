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
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(supabaseManager.categories, id: \.self) { category in
                    Button(action: {
                        withAnimation { () -> () in
                            supabaseManager.toggleFilter(category: category)
                        }
                    }) {
                        HStack {
                            Text(category)
                                .font(.body)
                                .foregroundColor(.black)
                                .padding(4)
                            Spacer()
                            if supabaseManager.filters.contains(category) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(raisinBlack)
                                    .padding(.trailing, 6)
                            }
                        }.frame(width: 180)
                    }
                }
            }
            .padding(12)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24).foregroundColor(snow)
                    RoundedRectangle(cornerRadius: 24).stroke(.black, lineWidth: 2)
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


struct FilterPopup_Previews: PreviewProvider {
    static var previews: some View {
        FilterDropdown().padding()
    }
}
