import UIKit
import MapKit

class MapController: NSObject {
    
    //MARK:- Actions
    @objc func showUserLocationClick(sender: UIButton!) {
        guard let map = map else { return }
        map.userTrackingMode = .follow
    }
    
    @objc func showPinClick(sender: UIButton!) {
        setMapCenter()
    }
    
    //MARK:- Properties
    weak var vc: UIViewController?
    var mapContainer: UIView
    var map: MKMapView?
    var centerButton: UIButton?
    var showPinButton: UIButton?
    let lm = CLLocationManager()
    var coordinates: [CLLocationCoordinate2D]
    var topLeftCoord = CLLocationCoordinate2D(latitude:-90, longitude:  180)
    var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
    var mapHasContent = false
    var polygonCreator = PolygonCreator()
    
    init(vc: UIViewController, mapContainer: UIView, coordinates: [CLLocationCoordinate2D]) {
        self.vc = vc
        self.mapContainer = mapContainer
        self.coordinates = coordinates
        super.init()
        initMap()
    }
    
    func initMap() {
        
        map = MKMapView(frame: CGRect(x: mapContainer.frame.minX, y: mapContainer.frame.minY, width: mapContainer.frame.size.width, height: mapContainer.frame.size.height))
        guard let map = map else { return }
        
        
        map.delegate = self
        map.showsUserLocation = true
        lm.requestWhenInUseAuthorization()
        mapContainer.addSubview(map)
        
        // Set constraints
        NSLayoutConstraint.activate([map.leadingAnchor.constraint(equalTo: mapContainer.leadingAnchor),
                                     map.trailingAnchor.constraint(equalTo: mapContainer.trailingAnchor),
                                     map.topAnchor.constraint(equalTo: mapContainer.topAnchor),
                                     map.bottomAnchor.constraint(equalTo: mapContainer.bottomAnchor)
            ])
        map.translatesAutoresizingMaskIntoConstraints = false
        
        clearCoordinatesAndMap()
        
        // Add markers
        for coordinate in coordinates.enumerated() {
            addMarker(title: "Marker number \(coordinate.offset)", coordinate: coordinate.element)
        }
        
        // Add polygon
        guard let polygon = polygonCreator.createPolygon(coordinates: coordinates) else { return }
        map.addOverlay(polygon)
        
        // Add userTracking button
        let trackButton = MKUserTrackingBarButtonItem(mapView: map)
        vc!.navigationItem.rightBarButtonItem = trackButton
        
        // Add showPinArea button
        if mapHasContent {
            addShowPinButton()
        }
        
        // Set map center
        setMapCenter()
    }
    
    func addShowPinButton() {
        showPinButton = UIButton()
        guard let showPinButton = showPinButton else { return }
        mapContainer.addSubview(showPinButton)
        NSLayoutConstraint.activate([
            showPinButton.trailingAnchor.constraint(equalTo: mapContainer.trailingAnchor, constant: -20),
            showPinButton.bottomAnchor.constraint(equalTo: mapContainer.bottomAnchor, constant: -20),
            showPinButton.heightAnchor.constraint(equalToConstant: 50),
            showPinButton.widthAnchor.constraint(equalToConstant: 50)
            ])
        showPinButton.translatesAutoresizingMaskIntoConstraints = false
        showPinButton.setImage(#imageLiteral(resourceName: "showPinsIcon"), for: UIControl.State.normal)
        showPinButton.backgroundColor = .white
        showPinButton.layer.cornerRadius = 25
        showPinButton.addTarget(self, action: #selector(showPinClick), for: .touchUpInside)
        showPinButton.layer.shadowColor = UIColor.black.cgColor
        showPinButton.layer.shadowOffset = CGSize(width: 0, height: -1)
        showPinButton.layer.shadowOpacity = 0.2
        showPinButton.layer.shadowRadius = 1
    }
    
    func addMarker(title: String, coordinate: CLLocationCoordinate2D) {
        let marker = MKPointAnnotation()
        marker.coordinate = coordinate
        marker.title = title
        guard let map = map else { return }
        map.addAnnotation(marker)
        mapHasContent = true
        
        // Check if it's on the edge
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, coordinate.longitude)
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, coordinate.latitude)
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, coordinate.longitude)
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, coordinate.latitude)
    }
    
    func setMapCenter() {
        if mapHasContent {
            guard let map = map else { return }
            var region = map.region
            region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
            region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
            region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.5;
            region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.5;
            
            self.map!.setRegion(region, animated: true)
        }
    }
    
    func  clearCoordinatesAndMap() {
        topLeftCoord = CLLocationCoordinate2D(latitude:-90, longitude:  180)
        bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        for annot in map!.annotations {
            map!.removeAnnotation(annot)
        }
        for overlay in map!.overlays {
            map!.removeOverlay(overlay)
        }
    }
}

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.strokeColor = UIColor.init(red: 0, green: 0.3, blue: 0.3, alpha: 1)
            renderer.lineWidth = 3
            return renderer
        } else {
            return MKOverlayRenderer()
        }
    }
}
