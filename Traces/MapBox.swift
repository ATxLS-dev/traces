//  MapBoxMapView.swift
//  Traces
//
//  Created by Bryce on 6/13/23.


import SwiftUI
import Supabase
import MapboxMaps

enum MapType {
    case newTrace, fixed, interactive
}

struct MapBox: View {

    @State var mapType: MapType
    
    @State var focalTrace: Trace = Trace(
        id: UUID(),
        creationDate: "2023-07-14",
        username: "John Doe",
        locationName: "Sample Location",
        latitude: 37.123456,
        longitude: -122.654321,
        content: "Sample content",
        category: "Sample category",
        user_id: UUID()
    )
    @State var annotations: [Trace] = []

    @ObservedObject var supabaseManager: SupabaseManager = SupabaseManager.shared
    @ObservedObject var locationManager: LocationManager = LocationManager.shared

    

    var body: some View {
        
        buildConvertedMap(mapType)
            .task {
                await supabaseManager.reloadTraces()
                await locationManager.checkLocationAuthorization()
            }
            .onAppear {
                getAnnotations()
            }
    }
    
    func buildConvertedMap(_ mapType: MapType) -> some View {
        switch mapType {
        case .newTrace:
            return MapBoxViewConverter(mapType: .newTrace, fixedLocation: locationManager.userLocation, userLocation: $locationManager.userLocation, annotations: $annotations)
        case .fixed:
            return MapBoxViewConverter(mapType: .fixed, fixedLocation: CLLocationCoordinate2D(latitude: focalTrace.latitude , longitude: focalTrace.longitude ), userLocation: $locationManager.userLocation, annotations: $annotations)
        case .interactive:
            return MapBoxViewConverter(mapType: .interactive, userLocation: $locationManager.userLocation, annotations: $annotations)
        }
    }

    func getAnnotations() {
        switch mapType {
        case .newTrace:
            annotations = []
        case .fixed:
            annotations = [focalTrace]
        case .interactive:
            annotations = supabaseManager.traces
        }
    }
}
    
struct MapBoxViewConverter: UIViewControllerRepresentable {
    
    var mapType: MapType
    var fixedLocation: CLLocationCoordinate2D?

    @Binding var userLocation: CLLocationCoordinate2D
    @Binding var annotations: [Trace]
    
    @ObservedObject var locationManager: LocationManager = LocationManager.shared
    @ObservedObject var themeManager: ThemeManager = ThemeManager.shared
    
    let defaultLocation = CLLocationCoordinate2D(latitude: 37.789467, longitude: -122.416772)
    
    func makeUIViewController(context: Context) -> MapViewController {
        let center: CLLocationCoordinate2D = fixedLocation ?? userLocation
        return MapViewController(mapType: mapType, center: center, style: StyleURI(rawValue: themeManager.theme.mapStyle)!, annotations: $annotations)
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        
        uiViewController.updateAnnotations(annotations)
        uiViewController.updateStyle(StyleURI(rawValue: themeManager.theme.mapStyle)!)
        switch mapType {
        case .newTrace:
            locationManager.updateUserLocation()
            let locationSnapshot = locationManager.userLocation
            uiViewController.centerOnPosition(locationSnapshot)
        case .fixed:
            uiViewController.centerOnPosition(fixedLocation ?? defaultLocation)
        case .interactive:
            uiViewController.centerOnPosition(userLocation)
        }
    }
    
}

class MapViewController: UIViewController {
    
    let mapType: MapType
    let center: CLLocationCoordinate2D
    let style: StyleURI
    let zoom: Double
    @Binding var annotations: [Trace]

    internal var mapView: MapView!
    
    init(
        mapType: MapType = .fixed,
        center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.83647410051574, longitude: 14.30582273457794),
         style: StyleURI = StyleURI(rawValue: "mapbox://styles/atxls/cliuqmp8400kv01pw57wxga7l")!,
         zoom: Double = 10,
         annotations: Binding<[Trace]>
    ) {
        self.mapType = mapType
        self.center = center
        self.style = style
        self.zoom = zoom
        self._annotations = annotations
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let resourceOptions = ResourceOptions(accessToken: mapBoxAccessToken)
        let cameraOptions = CameraOptions(center: center, zoom: mapType == .interactive ? zoom : 14)
        let myMapInitOptions = MapInitOptions(resourceOptions: resourceOptions, cameraOptions: cameraOptions, styleURI: style)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        updateAnnotations(annotations)
        mapView.ornaments.options = ornamentOptions()
        mapView.location.options.puckType = .puck2D()
        
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        if mapType != .interactive {
            mapView.gestures.options = disabledGestureOptions
        }
        
        self.view.addSubview(mapView)
    }
    
    func updateAnnotations(_ annotations: [Trace]) {
        switch mapType {
        case .newTrace, .fixed:
            let annotationSize = 42
            let customAnnotation = AnnotationView(frame: CGRect(x: 0, y: 0, width: annotationSize, height: annotationSize))
            let options = ViewAnnotationOptions(
                geometry: Point(center),
                allowOverlap: false,
                anchor: .center
            )
            try? mapView.viewAnnotations.add(customAnnotation, options: options)

        case .interactive:
            for annotation in annotations {
                let annotationSize = 24
                let customAnnotation = AnnotationView(frame: CGRect(x: 0, y: 0, width: annotationSize, height: annotationSize))
                let options = ViewAnnotationOptions(
                    geometry: Point(CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)),
                    allowOverlap: false,
                    anchor: .center
                )
                try? mapView.viewAnnotations.add(customAnnotation, options: options)
            }
            
        }
    }
    
    func centerOnPosition(_ position: CLLocationCoordinate2D) {
        let recenteredCamera: CameraOptions = CameraOptions(center: position, zoom: mapType == .interactive ? 12 : 14)
        mapView.mapboxMap.setCamera(to: recenteredCamera)
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
