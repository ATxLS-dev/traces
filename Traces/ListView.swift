//
//  TraceListView.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import SwiftUI
import MapKit

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trace.datePosted, ascending: true)],
        animation: .default)
    
    private var traces: FetchedResults<Trace>
    
    var body: some View {
        ScrollView {
            ForEach(traces) { trace in
                Button(action: TraceDetailView(trace: trace).showAndStack) {
                    TraceTile(trace: trace)
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { traces[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


struct ListedTraces_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
