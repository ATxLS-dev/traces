//  MapBoxMapView.swift
//  Traces
//
//  Created by Bryce on 6/13/23.


import SwiftUI
import Supabase
import MapboxMaps

enum MapType {
    case newTrace, fixed, interactable
}

struct MapBox: View {

//    @State var mapType: MapType
    
    @State var focalTrace: Trace?
    @State var annotations: [Trace]?

    var interactable: Bool = false

    @ObservedObject var supabaseManager: SupabaseManager = SupabaseManager.shared
    @ObservedObject var locationManager: LocationManager = LocationManager.shared
    @StateObject var themeManager: ThemeManager = ThemeManager.shared

    let defaultLocation = CLLocationCoordinate2D(latitude: 37.789467, longitude: -122.416772)
    
    var body: some View {
        MapBoxViewConverter(
            fixedLocation: CLLocationCoordinate2D(latitude: focalTrace?.latitude ?? locationManager.userLocation.latitude, longitude: focalTrace?.longitude ?? locationManager.userLocation.longitude),
//            fixedLocation: CLLocationCoordinate2D(latitude: focalTrace?.latitude, longitude: focalTrace?.longitude),
            userLocation: $locationManager.userLocation,
            interactable: interactable,
            style: StyleURI(rawValue: themeManager.theme.mapStyle)!,
            annotations: $annotations
        )
        .task {
            await supabaseManager.reloadTraces()
            await locationManager.checkLocationAuthorization()
        }
        .onAppear {
            getAnnotations()
        }
    }
    
    func getAnnotations() {
        if !interactable {
            annotations = focalTrace.map { [$0] }
        } else {
            annotations = supabaseManager.traces
        }
    }
}

struct MapBoxViewConverter: UIViewControllerRepresentable {
    
    var fixedLocation: CLLocationCoordinate2D
    @Binding var userLocation: CLLocationCoordinate2D
    let interactable: Bool
    @State var style: StyleURI
    @Binding var annotations: [Trace]?
    @ObservedObject var themeManager: ThemeManager = ThemeManager.shared
    
    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController(userLocation: interactable ? userLocation : fixedLocation, style: style, annotations: $annotations, interactable: interactable)
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        uiViewController.updateAnnotations(annotations ?? [])
        uiViewController.updateStyle(StyleURI(rawValue: themeManager.theme.mapStyle)!)
        if interactable {
            uiViewController.centerOnPosition(userLocation)
        }
        if annotations == [] {
            uiViewController.centerOnPosition(userLocation, isNewTrace: true)
        }

    }
    
}

class MapViewController: UIViewController {
    
    var userLocation: CLLocationCoordinate2D
    let style: StyleURI
    let zoom: Double
    @Binding var annotations: [Trace]?

    var interactable: Bool
    internal var mapView: MapView!
    
    init(userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.83647410051574, longitude: 14.30582273457794),
         style: StyleURI = StyleURI(rawValue: "mapbox://styles/atxls/cliuqmp8400kv01pw57wxga7l")!,
         zoom: Double = 10,
         annotations: Binding<[Trace]?>,
         interactable: Bool = false
    ) {
        self.userLocation = userLocation
        self.style = style
        self.zoom = zoom
        self._annotations = annotations
        self.interactable = interactable
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let resourceOptions = ResourceOptions(accessToken: mapBoxAccessToken)
        let cameraOptions = CameraOptions(center: userLocation, zoom: interactable ? zoom : 14)
        let myMapInitOptions = MapInitOptions(resourceOptions: resourceOptions, cameraOptions: cameraOptions, styleURI: style)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        updateAnnotations(annotations ?? [])
        mapView.ornaments.options = ornamentOptions()
        mapView.location.options.puckType = .puck2D()
        
        if !interactable {
            mapView.gestures.options = disabledGestureOptions
            mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        } else {
            mapView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        }
        
        self.view.addSubview(mapView)
    }
    
    func updateAnnotations(_ annotations: [Trace]) {

        for annotation in annotations {
            let options = ViewAnnotationOptions(
                geometry: Point(CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)),
                allowOverlap: false,
                anchor: .center
            )
            let annotationSize = interactable ? 24 : 42
            let customAnnotation = AnnotationView(frame: CGRect(x: 0, y: 0, width: annotationSize, height: annotationSize))
            try? mapView.viewAnnotations.add(customAnnotation, options: options)
        }
    }
    
    func centerOnPosition(_ position: CLLocationCoordinate2D, isNewTrace: Bool = false) {
        let recenteredCamera: CameraOptions = CameraOptions(center: position, zoom: 14)
        mapView.mapboxMap.setCamera(to: recenteredCamera)
        if isNewTrace {
            let options = ViewAnnotationOptions(
                geometry: Point(position),
                allowOverlap: false,
                anchor: .center
            )
            let annotationSize = interactable ? 24 : 42
            let customAnnotation = AnnotationView(frame: CGRect(x: 0, y: 0, width: annotationSize, height: annotationSize))
            try? mapView.viewAnnotations.add(customAnnotation, options: options)
        }
    }
    
    func updateStyle(_ style: StyleURI) {
        mapView.mapboxMap.loadStyleURI(style)
    }
    
    private let disabledGestureOptions = GestureOptions(panEnabled: false, pinchEnabled: false, rotateEnabled: false, simultaneousRotateAndPinchZoomEnabled: false, pinchZoomEnabled: false, pinchPanEnabled: false, pitchEnabled: false, doubleTapToZoomInEnabled: false, doubleTouchToZoomOutEnabled: false, quickZoomEnabled: false)
    
    private let ornamentOptions = {
        let scaleBarOptions = ScaleBarViewOptions(margins: CGPoint(x: 10, y: 60), visibility: .hidden)
        let logoOptions = LogoViewOptions(margins: CGPoint(x: 10, y: 110))
        let attributionOptions = AttributionButtonOptions(margins: CGPoint(x: 0, y: 106))
        return OrnamentOptions(scaleBar: scaleBarOptions, logo: logoOptions, attributionButton: attributionOptions)
    }
}
