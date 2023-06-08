//
//  NewTraceButton.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import PopupView

struct NewTraceButton: View {
    let width: CGFloat = 48
    var body: some View {
        VStack {
            Spacer()
            Button(action: NewTracePopup().showAndStack) {
                Image(systemName: "plus")
                    .frame(width: width, height: width)
                    .foregroundColor(snow)
                    .background(sweetGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .font(.system(size: width / 2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(snow, lineWidth: 1)
                    )
            }
            .shadow(color: .gray, radius: 4, x: 2, y: 2)
        }
        .padding(12)
    }
}

struct NewTraceButton_Previews: PreviewProvider {
    static var previews: some View {
        NewTraceButton()
    }
}
