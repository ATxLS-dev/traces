//
//  RoundedBorderRectangle.swift
//  Traces
//
//  Created by Bryce on 6/11/23.
//

import SwiftUI

struct RoundedBorderRectangle: View {
    let cornerRadius: CGFloat? = 16
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.black, lineWidth: 3)
                .shadow(color: .gray, radius: 6, x: 0, y: 6.0)
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
        }
    }
}

struct RoundedBorderRectangle_Previews: PreviewProvider {
    static var previews: some View {
        RoundedBorderRectangle()
    }
}
