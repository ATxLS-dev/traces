//
//  FilterView.swift
//  Traces
//
//  Created by Bryce on 9/3/23.
//

import SwiftUI

struct FilterView: View {
    
    @EnvironmentObject var feed: FeedController
    @EnvironmentObject var theme: ThemeController
    
    @State var proximityLimit = 10.0
    @State var editing = false
    @State var presentPopover = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Sort by: ")
                Spacer()
                Button(action: { presentPopover.toggle() }) {
                    Text(feed.filterMode.rawValue)
                        .foregroundStyle(theme.text)
                        .padding()
                    .background { BorderedCapsule() }
                }
                .popover(isPresented: $presentPopover) {
                    ForEach(FeedOption.allCases, id: \.self) { feedOption in
                        Text(feedOption.rawValue)
                            .padding()
                            .presentationCompactAdaptation(.none)
                    }
                }
            }
            proximitySlider
            ScrollView {
                ForEach(feed.categories) { category in
                    HStack {
                        Text(category.name)
                            .foregroundStyle(theme.text)
                            .padding()
                            .background(BorderedCapsule())
                        Spacer()
                    }
                    .padding(.vertical, 6)
                }
            }.frame(maxHeight: 400)
            }
        }
    
    var proximitySlider: some View {
        VStack {
            Text("\(Int(proximityLimit)) mi")
                .foregroundStyle(editing ? .red : .white)
            Slider(value: $proximityLimit, in: 0...25, step: 1, onEditingChanged: { editing in
                self.editing = editing })
        }
    }
}
