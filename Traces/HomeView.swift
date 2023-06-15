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
    @State private var categories: [String] = []
    let index: Int = 0

    var body: some View {
        ZStack {
            buildVerticalScrollView()
                .task {
                    await loadTraces()
                }
            buildFilterBar()
        }.onTapGesture {
            if showFilterDropdown {
                showFilterDropdown.toggle()
            }
        }
    }
}

extension HomeView {
    func buildFilterBar() -> some View {
        ZStack {
            Spacer()
                .background(.ultraThinMaterial)
                .opacity(showFilterDropdown ? 0.8 : 0.0)
                .animation(.easeInOut(duration: 0.4), value: showFilterDropdown)
            VStack {
                HStack {
//                    TextField("Filter by...", text: $filter)
                    Text("Filter").opacity(0.4)
                    Spacer()
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
                .overlay (alignment: .topLeading) {
                    VStack {
                        Spacer(minLength: 80)
                        if showFilterDropdown {
                            FilterDropdown(categories: categories)
                                .transition(.move(edge: self.showFilterDropdown ? .leading : .trailing))
                        }
                    }
                    .animation(.easeInOut(duration: 0.5), value: self.showFilterDropdown)
                }
                
                .onTapGesture {
                    showFilterDropdown.toggle()
                }
                Spacer()
            }
            .padding(.horizontal)
        }
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
                            TraceTile(trace: trace)
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
                categories = traces.map { $0.category }
                categories = Array(Set(categories))
                categories = categories.sorted { $0 < $1 }
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
