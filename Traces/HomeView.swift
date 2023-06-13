//
//  HomeView.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import Supabase

struct HomeView: View {
    
    @State var traces: [Trace] = []
    @State var error: Error?
    @State var filter: String = ""
    @State var showFilterDropdown: Bool = false
    let index: Int = 0

    var body: some View {
        ZStack {
            buildVerticalScrollView()
                .task {
                    await loadTraces()
                }
            buildFilterBar()
        }
    }
}

extension HomeView {
    func buildFilterBar() -> some View {
        VStack {
            HStack {
                TextField("Filter by...", text: $filter)
                buildSortButton()
            }
            .padding(4)
            .padding(.leading)
            .background(
                ZStack {
                    Capsule().fill(snow)
                    Capsule().stroke(.black, lineWidth: 2)
                }
            )
            .overlay (
                VStack {
                    if showFilterDropdown {
                        Spacer(minLength: 80)
                        FilterPopup(action: { data in
                        })
                    }
                }, alignment: .top
            ).onTapGesture {
                showFilterDropdown.toggle()
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

extension HomeView {
    func buildSortButton() -> some View {
        Button(action: {}) {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .scaleEffect(1.2)
                .foregroundColor(.black)
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.black, lineWidth: 2)
                            .clipShape(
                                Rectangle()
                                    .scale(1.1)
                                    .trim(from: 0.125, to: 0.625)
                                    .rotation(Angle(degrees: 180))
                            )
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .rotation(Angle(degrees: -90))
                            .stroke(.black, lineWidth: 2)
                    }
                )
        }
    }
}

extension HomeView {
    func buildVerticalScrollView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                Color.clear
                    .frame(height: 72)
                ForEach(traces) { trace in
                    HStack {
                        Button(action: TraceDetailView(trace: trace).showAndStack) {
                            TraceTileWide(trace: trace)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

extension HomeView {
    func loadTraces() async {
        let query = supabase.database.from("traces").select()
        Task {
            do {
                error = nil
                traces = try await query.execute().value
            } catch {
                self.error = error
                print(error)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
