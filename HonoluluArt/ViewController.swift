

import UIKit
import MapKit

class ViewController: UIViewController {
    //MARK: Properties
    var artworks: [Artwork] = []
    
    //para la autorizacion del usuario(ubicacion)
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    //Cheque la autorizacion del usuario para acceder a su ubicacion
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
        //para usar los markers
       // mapView.register(ArtworkMarkerView.self,
        //                 forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
       
        //para usar imagenes
        mapView.register(ArtworkView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        loadInitialData()
        mapView.delegate = self
        // Set initial location in Centro Oktana Montevideo.
        let initialLocation = CLLocation(latitude: -34.905992, longitude: -56.191504)
        
        
        // Set initial location in Onolulu to view Markers from Json data.
        //let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        
        // User Location: inicia el mapa donde esta el usuario localizado
        //mapView.showsUserLocation = true
        
        //Altura desde la que se ve.
        let regionRadius: CLLocationDistance = 200
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
        
        // show artwork on map
        let artwork = Artwork(title: "Banco Bandes",
                              locationName: "Sucursal Centro",
                              discipline: "Bank",
                              coordinate: CLLocationCoordinate2D(latitude: -34.905992, longitude:  -56.191504))
        //add my custom artwork to array
        artworks.append(artwork)
        //add all artworks to map.
        mapView.addAnnotations(artworks)
        createPolyline()
  }
    
    
    
    
    func loadInitialData() {
        // 1
        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            // 2
            let json = try? JSONSerialization.jsonObject(with: data),
            // 3
            let dictionary = json as? [String: Any],
            // 4
            let works = dictionary["data"] as? [[Any]]
            else { return }
        // 5
       
        let validWorks = works.compactMap { Artwork(json: $0) }
        artworks.append(contentsOf: validWorks)
    }
    
    func createPolyline() -> Void {
        let locations = [CLLocationCoordinate2D(latitude: -34.905992, longitude: -56.191504), CLLocationCoordinate2D(latitude: -34.905111, longitude: -56.191111), CLLocationCoordinate2D(latitude: -34.905333, longitude: -56.191333), CLLocationCoordinate2D(latitude: -34.905555, longitude: -56.191555), CLLocationCoordinate2D(latitude: -34.905888, longitude: -56.191888)
        ]
        let aPolyline = MKPolyline(coordinates: locations, count: locations.count)
        //let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
//let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        mapView.add(aPolyline)
        
        
    }
    

}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //set properties of the line
        if(overlay is MKPolyline) {
            print("**********************************************************************************************")
            let polylineRender = MKPolylineRenderer(overlay: overlay)
            polylineRender.strokeColor = UIColor.red.withAlphaComponent(CGFloat(0.5))
            polylineRender.lineWidth = 5
                return polylineRender
        }
        print("Llegooo???")
        return MKOverlayRenderer()
    }
    
    
    // 1
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        // 2
//        guard let annotation = annotation as? Artwork else { return nil }
//        // 3
//        let identifier = "marker"
//        var view: MKMarkerAnnotationView
//        // 4
//        //Intenta reusar una vista
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            // 5
//            //si no puede reusar la vista crea una nueva
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
}

