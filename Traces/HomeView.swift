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
    @ObservedObject var supabaseManager = SupabaseManager.shared
    @ObservedObject var themeManager = ThemeManager.shared

    var body: some View {
        ZStack {
            verticalScrollView()
                .task {
                    await supabaseManager.reloadTraces()
                }
            buildFilterBar()
        }
        .onTapGesture {
            if showFilterDropdown {
                showFilterDropdown.toggle()
            }
        }
        .background(themeManager.theme.background)
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
                    if !supabaseManager.filters.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(supabaseManager.filters), id: \.self) { category in
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
                        .shadow(color: themeManager.theme.shadow, radius: 6, x: 4, y: 4)
                )
                .onTapGesture {
                    showFilterDropdown.toggle()
                }
                FieldLabel(fieldLabel: "Filters")
                    .offset(x: -100, y: -72)
                Spacer()
            }
            .padding()
            VStack {
                Spacer(minLength: 80)
                if showFilterDropdown {
                    FilterDropdown()
                        .transition(.move(edge: self.showFilterDropdown ? .leading : .trailing))
                }
            }
            .padding(16)
            .animation(.easeInOut(duration: 0.5), value: self.showFilterDropdown)
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
                Spacer(minLength: 72)
                ForEach(
                    supabaseManager.filteredTraces.isEmpty ?
                    supabaseManager.traces : supabaseManager.filteredTraces
                ) { trace in
                    Button(action: TraceDetailPopup(trace: trace).showAndStack) {
                        TraceTile(trace: trace)
                    }
                    .padding(.horizontal)
                }
                Spacer(minLength: 72)
            }
        }
        .refreshable {
            Task {
                await supabaseManager.reloadTraces()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
