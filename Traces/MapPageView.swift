//
//  MapView.swift
//  GeoTag
//
//  Created by Bryce on 5/11/23.
//

import SwiftUI
import MapKit

struct MapPageView: View {

    @State var center = CLLocationCoordinate2D(latitude: 37.789467, longitude: -122.416772)

    var body: some View {
        MapBox(center: center, interactable: true)
            .offset(y: -12.5)
    }
}

struct MapPageViews: PreviewProvider {
    static var previews: some View {
        MapBox()
    }
}

//struct MapView: UIViewRepresentable {
//    @Binding var annotations: [MKAnnotation]
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//        return mapView
//    }
//
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        uiView.removeAnnotations(uiView.annotations)
//        uiView.addAnnotations(annotations)
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: MapView
//
//        init(_ parent: MapView) {
//            self.parent = parent
//        }
//
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
//            annotationView.canShowCallout = true
//            return annotationView
//        }
//
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            let zoomLevel = mapView.visibleMapRect.size.width
//            let zoomThreshold: Double = 200 // Adjust this value based on your requirements
//
//            for annotation in mapView.annotations {
//                if let annotationView = mapView.view(for: annotation) {
//                    annotationView.isHidden = zoomLevel <= zoomThreshold
//                }
//            }
//        }
//    }
//}



