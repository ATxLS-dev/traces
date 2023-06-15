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
    
    var body: some View {
        Button(action: {
            withAnimation { () -> () in
                supabaseManager.toggleFilter(category: category)
            }
        }) {
            HStack(spacing: 12) {
                Text(category)
                    .font(.caption)
                Image(systemName: "x.circle")
                    .opacity(0.2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    Capsule()
                        .fill(snow)
                    Capsule()
                        .stroke(.black, lineWidth: 1.4)
                }
            )
            .foregroundColor(raisinBlack)
        }.padding(2)
    }
}

struct CategoryTag_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTag(category: "Adventure")
    }
}
