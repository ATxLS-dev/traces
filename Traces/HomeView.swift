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
                .padding(.leading)
                .background(
                    ZStack {
                        Capsule().fill(themeManager.theme.backgroundAccent)
                        Capsule().stroke(themeManager.theme.border, lineWidth: 2)
                    }
                )
                .onTapGesture {
                    showFilterDropdown.toggle()
                }
                Text("Filters")
                    .foregroundColor(themeManager.theme.text)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [themeManager.theme.background, themeManager.theme.backgroundAccent]),
                                    startPoint: UnitPoint(x: 0, y: 0.4),
                                    endPoint: UnitPoint(x: 0, y: 0.6)
                                )
                            )
                        )
                    .offset(x: -100, y: -78)
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
            Image(systemName: "line.3.horizontal.decrease.circle")
                .scaleEffect(1.2)
                .foregroundColor(themeManager.theme.text)
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(themeManager.theme.button)
                            .clipShape(
                                Rectangle()
                                    .scale(2)
                                    .trim(from: 0, to: 0.502)
                                    .rotation(Angle(degrees: -135))
                            )
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(Angle(degrees: -90))
                            .fill(themeManager.theme.button)
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.theme.text, lineWidth: 2)
                            .clipShape(
                                Rectangle()
                                    .scale(1.1)
                                    .trim(from: 0.125, to: 0.625)
                                    .rotation(Angle(degrees: 180))
                            )
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(Angle(degrees: -90))
                            .stroke(themeManager.theme.text, lineWidth: 2)
                    }
                )
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
                    HStack {
                        Button(action: TraceDetailPopup(trace: trace).showAndStack) {
                            TraceTile(trace: trace)
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer(minLength: 72)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
