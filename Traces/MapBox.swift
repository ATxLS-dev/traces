//  MapBoxMapView.swift
//  Traces
//
//  Created by Bryce on 6/13/23.


import SwiftUI
import Supabase
import MapKit
import MapboxMaps

struct MapBox: View {

    var isInteractive: Bool = false
    var focalTrace: Trace?
    @State var annotations: [Trace] = []

    @ObservedObject var supabaseManager: SupabaseManager = SupabaseManager.shared
    @ObservedObject var locationManager: LocationManager = LocationManager.shared
    @ObservedObject var themeManager: ThemeManager = ThemeManager.shared

    var body: some View {
        if isInteractive {
            buildInteractiveMap()
        } else {
            buildMiniMap()
        }
    }
    
    func buildMiniMap() -> some View {
        if focalTrace != nil {
            return MiniMapViewConverter(center: CLLocationCoordinate2D(latitude: focalTrace!.latitude, longitude: focalTrace!.longitude))
        } else {
            return MiniMapViewConverter(center: locationManager.userLocation)
        }
        
    }
    
    func buildInteractiveMap() -> some View {
        InteractiveMapViewConverter()
            .task {
                await supabaseManager.reloadTraces()
                await locationManager.checkLocationAuthorization()
            }
            .onAppear {
                annotations = supabaseManager.traces
            }
    }
}
    
struct InteractiveMapViewConverter: UIViewControllerRepresentable {

    @ObservedObject var themeManager: ThemeManager = ThemeManager.shared
    @ObservedObject var locationManager: LocationManager = LocationManager.shared
    @ObservedObject var supabaseManager: SupabaseManager = SupabaseManager.shared
    
    func makeUIViewController(context: Context) -> InteractiveMapViewController {
        locationManager.snapshotLocation()
        print(locationManager.userLocation)
        return InteractiveMapViewController(center: locationManager.lastLocation, style: themeManager.theme.mapStyle, annotations: supabaseManager.traces)
    }
    
    func updateUIViewController(_ uiViewController: InteractiveMapViewController, context: Context) {
        uiViewController.centerOnPosition(locationManager.userLocation)
        uiViewController.updateAnnotations(supabaseManager.traces)
        uiViewController.updateStyle(themeManager.theme.mapStyle)
    }
}

class InteractiveMapViewController: UIViewController {
    
    let center: CLLocationCoordinate2D
    let style: StyleURI
    let zoom: Double
    var annotations: [Trace]
    
    internal var mapView: MapView!
    
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
        center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.83647410051574, longitude: 14.30582273457794),
        style: StyleURI = StyleURI(rawValue: "mapbox://styles/atxls/cliuqmp8400kv01pw57wxga7l")!,
        zoom: Double = 10,
        annotations: [Trace]
    ) {
        self.center = center
        self.style = style
        self.zoom = zoom
        self.annotations = annotations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let resourceOptions = ResourceOptions(accessToken: mapBoxAccessToken)
        let cameraOptions = CameraOptions(center: center, zoom: zoom)
        let myMapInitOptions = MapInitOptions(resourceOptions: resourceOptions, cameraOptions: cameraOptions, styleURI: style)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        updateAnnotations(annotations)
        mapView.ornaments.options = ornamentOptions()
        mapView.location.options.puckType = .puck2D()
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        stackView.addArrangedSubview(mapView)
        
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
    }
    
    func updateAnnotations(_ annotations: [Trace]) {
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
    
    @objc private func annotationTapped(_ gesture: UITapGestureRecognizer) {
        guard let annotationView = gesture.view as? AnnotationView else {
            return
        }
        
        if let selectedAnnotation = annotations.first(where: { $0.id == annotationView.trace?.id }) {
            let popup = TraceDetailPopup(trace: selectedAnnotation)
            popup.showAndStack()
        }
    }
    
    func centerOnPosition(_ position: CLLocationCoordinate2D) {
        let recenteredCamera: CameraOptions = CameraOptions(center: position, zoom: 12)
        mapView.mapboxMap.setCamera(to: recenteredCamera)
    }
    
    func updateStyle(_ style: StyleURI) {
        mapView.mapboxMap.loadStyleURI(style)
    }
    
    private let ornamentOptions = {
        let scaleBarOptions = ScaleBarViewOptions(visibility: .hidden)
        let logoOptions = LogoViewOptions(position: .topRight, margins: CGPoint(x: 40, y: 40))
        let attributionOptions = AttributionButtonOptions(position: .topRight, margins: CGPoint(x: 0, y: 20))
        return OrnamentOptions(scaleBar: scaleBarOptions, logo: logoOptions, attributionButton: attributionOptions)
    }
}

struct MiniMapViewConverter: UIViewControllerRepresentable {

    var center: CLLocationCoordinate2D?

    @ObservedObject var locationManager: LocationManager = LocationManager.shared
    @ObservedObject var themeManager: ThemeManager = ThemeManager.shared
    
    func makeUIViewController(context: Context) -> MiniMapViewController {
        MiniMapViewController(center: center ?? locationManager.lastLocation, style: themeManager.theme.mapStyle)
    }
    
    func updateUIViewController(_ uiViewController: MiniMapViewController, context: Context) {
        uiViewController.updateStyle(themeManager.theme.mapStyle)
    }
}

class MiniMapViewController: UIViewController {
    
    let center: CLLocationCoordinate2D
    let style: StyleURI
    
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
        center: CLLocationCoordinate2D,
        style: StyleURI = StyleURI(rawValue: "mapbox://styles/atxls/cliuqmp8400kv01pw57wxga7l")!
    ) {
        self.center = center
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let resourceOptions = ResourceOptions(accessToken: mapBoxAccessToken)
        let cameraOptions = CameraOptions(center: center, zoom: 14)
        let myMapInitOptions = MapInitOptions(resourceOptions: resourceOptions, cameraOptions: cameraOptions, styleURI: style)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.ornaments.options = ornamentOptions()
        mapView.location.options.puckType = .puck2D()
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        mapView.gestures.options = disabledGestureOptions
        
        stackView.addArrangedSubview(mapView)
        
        snapshotView = UIImageView()
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        

        stackView.addSubview(snapshotView)
        stackView.removeArrangedSubview(mapView)
        let annotation = AnnotationView(frame: CGRect(x: 36, y: 36, width: 72, height: 72))
        stackView.addSubview(annotation)

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
            initializeSnapshotter(self.style)
        }
    }
    
    func centerOnPosition(_ position: CLLocationCoordinate2D) {
        let recenteredCamera: CameraOptions = CameraOptions(center: position, zoom: 14)
        mapView.mapboxMap.setCamera(to: recenteredCamera)
    }
    
    func updateStyle(_ style: StyleURI) {
        mapView.mapboxMap.loadStyleURI(style)
        
        if snapshotter != nil {
            snapshotter.style.uri = style
        }
    }
    
    private func initializeSnapshotter(_ style: StyleURI) {
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
    
    private let disabledGestureOptions = GestureOptions(panEnabled: false, pinchEnabled: false, rotateEnabled: false, simultaneousRotateAndPinchZoomEnabled: false, pinchZoomEnabled: false, pinchPanEnabled: false, pitchEnabled: false, doubleTapToZoomInEnabled: false, doubleTouchToZoomOutEnabled: false, quickZoomEnabled: false)
    
    private let ornamentOptions = {
        let scaleBarOptions = ScaleBarViewOptions(margins: CGPoint(x: 10, y: 60), visibility: .hidden)
        let logoOptions = LogoViewOptions(margins: CGPoint(x: 10, y: 110))
        let attributionOptions = AttributionButtonOptions(margins: CGPoint(x: 0, y: 106))
        return OrnamentOptions(scaleBar: scaleBarOptions, logo: logoOptions, attributionButton: attributionOptions)
    }
}
