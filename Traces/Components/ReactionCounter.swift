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
            HStack {
                Text("\(reaction.occurences)")
                    .foregroundStyle(theme.text.opacity(reaction.occurences == 0 ? 0.4 : 1))
                Image(systemName: reaction.value)
                    .foregroundStyle(theme.text.opacity(reaction.occurences == 0 ? 0.4 : 1))
            }
            .scaleEffect(0.8)
        }
    }

}
