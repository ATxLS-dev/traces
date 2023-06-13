//
//  MapView.swift
//  GeoTag
//
//  Created by Bryce on 5/11/23.
//

import SwiftUI
import MapKit

struct AppleMapView: View {
    @State var region = MKCoordinateRegion(center: .init(latitude: 37.789467, longitude: -122.416772), latitudinalMeters: 300, longitudinalMeters: 300)

    var body: some View {
        Map(coordinateRegion: $region,
            interactionModes: MapInteractionModes.all,
            showsUserLocation: true,
            annotationItems: MapTraces,
            annotationContent: { location in
            MapAnnotation (coordinate: location.coordinate) {
                buildTracePin(location: location.name)
                }
            }
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct AppleMapViews: PreviewProvider {
    static var previews: some View {
        AppleMapView()
    }
}

extension AppleMapView {
    func buildTracePin(location: String) -> some View {
        VStack {
            Rectangle()
                .foregroundColor(sweetGreen)
                .frame(width: 24, height: 24)

//            Text(location)
//                .frame(width: 180)
//                .multilineTextAlignment(.center)
//                .opacity(0.2)
//            Image(systemName: "pin.fill").foregroundColor(sweetGreen)
        }
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



