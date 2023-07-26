//  MapBoxMapView.swift
//  Traces
//
//  Created by Bryce on 6/13/23.


import SwiftUI
import Supabase
import MapKit
import MapboxMaps

enum MapType {
    case newTrace, fixed, interactive
}

struct MapBox: View {

    @State var mapType: MapType
    @State var focalTrace: Trace = Trace(
        id: UUID(),
        userID: UUID(),
        creationDate: Date.currentTimeStamp.formatted(),
        latitude: 37.123456,
        longitude: -122.654321,
        locationName: "Sample Location",
        content: "Sample content",
        categories: ["Sample category"]
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
            return MapBoxViewConverter(mapType: .fixed, fixedLocation: CLLocationCoordinate2D(latitude: focalTrace.latitude, longitude: focalTrace.longitude), userLocation: $locationManager.userLocation, annotations: $annotations)
        case .interactive:
            return MapBoxViewConverter(mapType: .interactive, userLocation: $locationManager.lastLocation, annotations: $annotations)
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
            uiViewController.centerOnPosition(userLocation)
        case .fixed:
            uiViewController.centerOnPosition(fixedLocation ?? defaultLocation)
        case .interactive:
            break
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
    public var snapshotter: Snapshotter!
    public var snapshotView: UIImageView!
    private var snapshotting = false
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: view.safeAreaLayoutGuide.layoutFrame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 12.0
        return stackView
    }()
    
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
        
        stackView.addArrangedSubview(mapView)
        
        snapshotView = UIImageView()
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        
        if mapType != .interactive {
            stackView.addSubview(snapshotView)
            stackView.removeArrangedSubview(mapView)
            let annotation = AnnotationView(frame: CGRect(x: 36, y: 36, width: 72, height: 72))
            stackView.addSubview(annotation)
        }
        
    
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if snapshotter == nil {
            initializeSnapshotter()
        }
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
                
                let annotationSize = 42
                let customAnnotation = AnnotationView(frame: CGRect(x: 0, y: 0, width: annotationSize, height: annotationSize), trace: annotation)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(annotationTapped(_:)))
                customAnnotation.addGestureRecognizer(tapGesture)
                
                let options = ViewAnnotationOptions(
                    geometry: Point(CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)),
                    allowOverlap: false,
                    anchor: .center
                )
                try? mapView.viewAnnotations.add(customAnnotation, options: options)
            }
            
        }
    }
    
    @objc private func annotationTapped(_ gesture: UITapGestureRecognizer) {
        guard let annotationView = gesture.view as? AnnotationView else {
            return
        }
        
        
        if let selectedAnnotation = annotations.first(where: { $0.id == annotationView.trace?.id }) {
            print(selectedAnnotation.locationName)
            let popup = TraceDetailPopup(trace: selectedAnnotation)
            popup.showAndStack()
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
    
    private func initializeSnapshotter() {
        let size = CGSize(
            width: view.safeAreaLayoutGuide.layoutFrame.width,
            height: view.safeAreaLayoutGuide.layoutFrame.height)
        let options = MapSnapshotOptions(
            size: size,
            pixelRatio: UIScreen.main.scale,
            resourceOptions: ResourceOptionsManager.default.resourceOptions,
            showsLogo: false,
            showsAttribution: false)
        
        snapshotter = Snapshotter(options: options)
        snapshotter.style.uri = style
        
        mapView.mapboxMap.onEvery(event: .mapIdle) { [weak self] _ in
            guard let self = self, !self.snapshotting else {
                return
            }
            
            let snapshotterCameraOptions = CameraOptions(cameraState: self.mapView.cameraState)
            self.snapshotter.setCamera(to: snapshotterCameraOptions)
            self.startSnapshot()
        }
    }
    
    public func startSnapshot() {
        snapshotting = true
        snapshotter.start(overlayHandler: nil) { ( result ) in
            switch result {
            case .success(let image):
                self.snapshotView.image = image
            case .failure(let error):
                print("Error generating snapshot: \(error)")
            }
            self.snapshotting = false
        }
    }

}
