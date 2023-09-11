//
//  ReactionCounter.swift
//  Traces
//
//  Created by Bryce on 9/3/23.
//

import SwiftUI

struct ReactionCounter: View {
    
    let reaction: CountedReaction
    @EnvironmentObject var theme: ThemeController
    
    init(_ reaction: CountedReaction) {
        self.reaction = reaction
    }
    
    var body: some View {
        reactionCounter()
    }
    
    func reactionCounter() -> some View {
        ZStack {
//            BorderedCapsule(hasThinBorder: true)
//                .frame(width: 54)
            HStack {
                Text("\(reaction.occurences)")
                    .foregroundStyle(theme.text)
                Image(systemName: reaction.value)
                    .foregroundStyle(theme.text)
            }
            .scaleEffect(0.8)
//            .padding(.vertical, 4)
        }
    }

}
