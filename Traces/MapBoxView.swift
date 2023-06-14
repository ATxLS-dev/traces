//  MapBoxMapView.swift
//  Traces
//
//  Created by Bryce on 6/13/23.


import SwiftUI
import Supabase
import MapboxMaps

struct MapBoxView: View {
    @State var center = CLLocationCoordinate2D(latitude: 37.789467, longitude: -122.416772)
    @State var traces: [Trace] = []
    @State var error: Error?
    @State var filter: String = ""
    @State var annotations: [CLLocationCoordinate2D] = []
    
    var body: some View {
        MapBoxViewConverter(center: center, annotations: $annotations)
            .task {
                await loadTraces()
            }
            .onAppear {
                updateAnnotations()
            }
    }
    
    func loadTraces() async {
        let query = supabase.database.from("traces").select()
        do {
            error = nil
            traces = try await query.execute().value
            updateAnnotations()
        } catch {
            self.error = error
            print(error)
        }
    }
    
    func updateAnnotations() {
        annotations = traces.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }
}

struct MapBoxViewConverter: UIViewControllerRepresentable {
    let center: CLLocationCoordinate2D
    @Binding var annotations: [CLLocationCoordinate2D]
    
    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController(center: center, annotations: $annotations)
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        uiViewController.updateAnnotations(annotations: annotations)
    }
}

class MapViewController: UIViewController {
    let center: CLLocationCoordinate2D
    let style: StyleURI
    let zoom: Double
    @Binding var annotations: [CLLocationCoordinate2D]
    internal var mapView: MapView!
    
    init(center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.83647410051574, longitude: 14.30582273457794),
         style: StyleURI = StyleURI(rawValue: "mapbox://styles/atxls/cliuqmp8400kv01pw57wxga7l")!,
         zoom: Double = 10,
         annotations: Binding<[CLLocationCoordinate2D]>
    ) {
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
        
        let myResourceOptions = ResourceOptions(accessToken: mapBoxAccessToken)
        let cameraOptions = CameraOptions(center: center, zoom: zoom)
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: cameraOptions, styleURI: style)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        updateAnnotations(annotations: annotations)
        
        mapView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        self.view.addSubview(mapView)
    }
    
    func updateAnnotations(annotations: [CLLocationCoordinate2D]) {
        var circleAnnotations: [CircleAnnotation] = []
        
        for annotation in annotations {
            let circleAnnotation = CircleAnnotation(centerCoordinate: annotation)
            circleAnnotations.append(circleAnnotation)
        }
        
        let circleAnnotationManager = mapView.annotations.makeCircleAnnotationManager()
        circleAnnotationManager.annotations = circleAnnotations
    }
}
