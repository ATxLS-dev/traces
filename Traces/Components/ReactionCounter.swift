//
//  ReactionCounter.swift
//  Traces
//
//  Created by Bryce on 9/3/23.
//

import SwiftUI

struct ReactionCounter: View {
    
    let reaction: CountedReaction
    @StateObject var themeController = ThemeController.shared
    
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
                    .foregroundStyle(themeController.theme.text)
                Image(systemName: reaction.value)
                    .foregroundStyle(themeController.theme.text)
            }
            .scaleEffect(0.8)
//            .padding(.vertical, 4)
        }
    }

}
