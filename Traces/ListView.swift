//
//  TraceListView.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import MapKit

struct ListView: View {
    
    let traces: [Trace] = []
    
    var body: some View {
        ScrollView {
            ForEach(traces) { trace in
                Button(action: TraceDetailView(trace: trace).showAndStack) {
                    TraceTile(trace: trace)
                }
            }
        }
    }
}

struct ListedTraces_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
