//
//  HomeView.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import Supabase

struct HomeView: View {
    
    @State var showFilterDropdown: Bool = false
    @StateObject var feedController = FeedController.shared
    @EnvironmentObject var theme: ThemeController

    var body: some View {
        ZStack {
            verticalScrollView()
                .task {
                    await feedController.syncUnsortedFeed()
                }
            buildFilterBar()
        }
        .onTapGesture {
            if showFilterDropdown {
                showFilterDropdown.toggle()
            }
        }
        .background(theme.background)
    }
}

extension HomeView {
    func buildFilterBar() -> some View {
        ZStack {
            Spacer()
                .background(.ultraThinMaterial)
                .opacity(showFilterDropdown ? 0.8 : 0.0)
                .animation(.easeInOut(duration: 0.3), value: showFilterDropdown)
            VStack {
                HStack {
                    if !feedController.filters.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(feedController.filters), id: \.self) { category in
                                    CategoryTag(category: category)
                                }
                            }.transition(AnyTransition.scale)
                        }
                    }
                    Spacer()
                    sortButton()
                }
                .padding(4)
                .padding(.leading, 4)
                .background(
                    BorderedCapsule()
                        .shadow(color: theme.shadow, radius: 6, x: 4, y: 4)
                )
                .onTapGesture {
                    showFilterDropdown.toggle()
                }
                FieldLabel(fieldLabel: "Filters")
                    .offset(x: -100, y: -70)
                Spacer()
            }
            .padding()
            VStack {
                Spacer(minLength: 80)
                if showFilterDropdown {
                    FilterDropdown()
                        .transition(.move(edge: .leading))
                }
            }
            .padding(16)
            .animation(
                .interactiveSpring(response: 0.45, dampingFraction: 0.8, blendDuration: 0.69), value: self.showFilterDropdown)
        }
    }
}

extension HomeView {
    func sortButton() -> some View {
        Button(action: {
            showFilterDropdown.toggle()
        }) {
            BorderedHalfButton()
        }
    }
}

extension HomeView {
    func verticalScrollView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                Spacer(minLength: 96)
                ForEach(feedController.feed) { trace in
                    TraceTile(trace: trace)
                }
                Spacer(minLength: 96)
            }
        }
    }
}
