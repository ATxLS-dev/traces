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

    var body: some View {
        ScrollView() {
            VStack {
                HStack {
                    Text("Traces Near Me")
                        .font(.title)
                    Spacer()
                }
                .padding()
                buildHorizontalScrollView()
                Spacer()
                HStack {
                    Text("Recent Traces")
                        .font(.title)
                    Spacer()
                }
                .padding()
                buildHorizontalScrollView()
                Spacer()
            }
        }
        .background(snow)
        .task {
            await loadTraces()
        }
    }
}

extension HomeView {
    func buildHorizontalScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(traces) { trace in
                    Button(action: TraceDetailView(trace: trace).showAndStack) {
                        TraceTileTall(trace: trace)
                    }
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
