//
//  FilterPopup.swift
//  Traces
//
//  Created by Bryce on 6/12/23.
//

import SwiftUI
import Supabase

struct FilterDropdown: View {
    
    @State var traces: [Trace] = []
    @State var error: Error?
    @State var filter: String = ""
    @State var categories: [String] = []
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {}) {
                        Text(category)
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(4)
                    }
                }
            }
            .padding(.all, 12)
            .padding(.trailing, 69)
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
