//
//  HomeView.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import Supabase
import FontAwesomeSwiftUI

struct HomeView: View {
    
    @State var traces: [Trace] = []
    @State var error: Error?
    let index: Int = 0

    var body: some View {
        ZStack {

            buildVerticalScrollView()
                .task {
                    await loadTraces()
                }
            HStack {
                Spacer()
                VStack {
                    buildSortButton()
                    Spacer()
                }
            }
            .padding()
        }
    }
}

extension HomeView {
    func buildSortButton() -> some View {
        Button(action: {}) {
            Image(systemName: "ellipsis.circle")
                .scaleEffect(1.2)
                .foregroundColor(.black)
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 4)
                        RoundedRectangle(cornerRadius: 16)
                            .fill(skyBlue)
                    }
                )
        }
    }
}

extension HomeView {
    func buildVerticalScrollView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ForEach(traces) { trace in
                    HStack {
                        Button(action: TraceDetailView(trace: trace).showAndStack) {
                            TraceTileWide(trace: trace)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                }
            }
        }
    }
}

extension HomeView {
    func buildHorizontalScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(traces) { trace in
                    Button(action: TraceDetailView(trace: trace).showAndStack) {
                        TraceTileWide(trace: trace)
                    }
                }
            }
            .background(snow)
            .padding()
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
