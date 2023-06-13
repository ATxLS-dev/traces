//
//  MapBoxMapView.swift
//  Traces
//
//  Created by Bryce on 6/13/23.
//

import SwiftUI
import MapboxMaps

struct MapBoxMapView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController()
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
    }
}


class MapViewController: UIViewController {
    internal var mapView: MapView!
    override public func viewDidLoad() {
        super.viewDidLoad()
        let myResourceOptions = ResourceOptions(accessToken: mapBoxAccessToken)
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: 40.83647410051574, longitude: 14.30582273457794), zoom: 4.5)
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)

        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        self.view.addSubview(mapView)
    }
}
