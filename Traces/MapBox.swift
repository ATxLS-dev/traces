//  MapBoxMapView.swift
//  Traces
//
//  Created by Bryce on 6/13/23.


import SwiftUI
import Supabase
import MapboxMaps

struct MapBox: View {

    @State var center: CLLocationCoordinate2D?
    @State var annotations: [CLLocationCoordinate2D] = []
    
    var interactable: Bool = false

    @ObservedObject var supabaseManager: SupabaseManager = SupabaseManager.shared
    @ObservedObject var locationManager: LocationManager = LocationManager()
    @StateObject var themeManager: ThemeManager = ThemeManager.shared

    let defaultLocation = CLLocationCoordinate2D(latitude: 37.789467, longitude: -122.416772)
    
    var body: some View {
        MapBoxViewConverter(
            center: center ?? defaultLocation,
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
            annotations = [center ?? defaultLocation]
        } else {
            annotations = supabaseManager.traces.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        }
    }
}

struct MapBoxViewConverter: UIViewControllerRepresentable {
    
    let center: CLLocationCoordinate2D
    let interactable: Bool
    @State var style: StyleURI
    @Binding var annotations: [CLLocationCoordinate2D]
    @ObservedObject var themeManager: ThemeManager = ThemeManager.shared
    
    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController(center: center, style: style, annotations: $annotations, themeManager: themeManager, interactable: interactable)
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        uiViewController.updateAnnotations(annotations)
        uiViewController.updateStyle(StyleURI(rawValue: themeManager.theme.mapStyle)!)
        uiViewController.centerOnPosition(center)
    }
    
}

class MapViewController: UIViewController {
    
    let center: CLLocationCoordinate2D
    let style: StyleURI
    let zoom: Double
    @Binding var annotations: [CLLocationCoordinate2D]
    
    let themeManager: ThemeManager
    var interactable: Bool
    internal var mapView: MapView!
    
    init(center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.83647410051574, longitude: 14.30582273457794),
         style: StyleURI = StyleURI(rawValue: "mapbox://styles/atxls/cliuqmp8400kv01pw57wxga7l")!,
         zoom: Double = 10,
         annotations: Binding<[CLLocationCoordinate2D]>,
         themeManager: ThemeManager,
         interactable: Bool = false
    ) {
        self.center = center
        self.style = style
        self.zoom = zoom
        self._annotations = annotations
        self.themeManager = themeManager
        self.interactable = interactable
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let resourceOptions = ResourceOptions(accessToken: mapBoxAccessToken)
        let cameraOptions = CameraOptions(center: center, zoom: interactable ? zoom : 14)
        let myMapInitOptions = MapInitOptions(resourceOptions: resourceOptions, cameraOptions: cameraOptions, styleURI: style)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        updateAnnotations(annotations)
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
    
    func updateAnnotations(_ annotations: [CLLocationCoordinate2D]) {
        for annotation in annotations {
            let options = ViewAnnotationOptions(
                geometry: Point(annotation),
                allowOverlap: false,
                anchor: .center
            )
            let annotationSize = interactable ? 24 : 42
            let customAnnotation = AnnotationView(frame: CGRect(x: 0, y: 0, width: annotationSize, height: annotationSize))
            try? mapView.viewAnnotations.add(customAnnotation, options: options)
        }
    }
    
    func centerOnPosition(_ position: CLLocationCoordinate2D) {
        let recenteredCamera: CameraOptions = CameraOptions(center: position, zoom: 14)
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
