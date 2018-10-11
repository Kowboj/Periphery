import UIKit
import MapKit

class PolygonCreator {
    
    func createPolygon(coordinates: [CLLocationCoordinate2D]) -> MKPolygon? {
        
        // It's the final array containing coordinates in the proper order
        var polygonCoordinates = [CLLocationCoordinate2D]()
        if coordinates.count <= 2 {
            
            print("Need at least 3 coordinates")
            return nil
            
        } else if coordinates.count > 2 {
            
            var westPoint = CLLocationCoordinate2DMake(CLLocationDegrees(0), CLLocationDegrees(180))
            var eastPoint = CLLocationCoordinate2DMake(CLLocationDegrees(0), CLLocationDegrees(-180))
            
            // Get westmost and eastmost points
            for coordinate in coordinates {
                if coordinate.longitude < westPoint.longitude {
                    westPoint = coordinate
                }
                if coordinate.longitude > eastPoint.longitude {
                    eastPoint = coordinate
                }
            }
            
            // Begin with the westmost point
            polygonCoordinates.append(westPoint)
            
            // What is it all about? Search for point with lowest tangens - (x/y -> min)
            var pointWithLowestTangens = CLLocationCoordinate2D()
            var lastAddedPoint = westPoint
            var lowestTangens: Double = 99999 // as maximum tangens is infinity
            var numberOfAttempts = 0
            var noMoreAttempts = false
            
            // Go east until we reach the eastmost point
            while pointWithLowestTangens.longitude != eastPoint.longitude && pointWithLowestTangens.latitude != eastPoint.latitude {
                if !noMoreAttempts { // if there is a point above lastAddedPoint
                    numberOfAttempts = 0
                    for coord in coordinates {
                        
                        // Look for points in the north
                        if coord.latitude > lastAddedPoint.latitude {
                            if (coord.longitude - lastAddedPoint.longitude)/(coord.latitude - lastAddedPoint.latitude) < lowestTangens {
                                lowestTangens = (coord.longitude - lastAddedPoint.longitude)/(coord.latitude - lastAddedPoint.latitude)
                                pointWithLowestTangens = coord
                            }
                        } else {
                            numberOfAttempts += 1
                            if numberOfAttempts == coordinates.count-1 {
                                noMoreAttempts = true
                            }
                        }
                    }
                    if pointWithLowestTangens.latitude != 0 {
                        polygonCoordinates.append(pointWithLowestTangens)
                        lastAddedPoint = pointWithLowestTangens
                    }
                    lowestTangens = 1000
                } else { // if there is no points above lastAddedPoint
                    for coord in coordinates {
                        
                        // Look for points in the south
                        if coord.latitude < lastAddedPoint.latitude && coord.longitude > lastAddedPoint.longitude {
                            if (lastAddedPoint.latitude - coord.latitude)/(coord.longitude - lastAddedPoint.longitude) < lowestTangens {
                                lowestTangens = (lastAddedPoint.latitude - coord.latitude)/(coord.longitude - lastAddedPoint.longitude)
                                pointWithLowestTangens = coord
                            }
                        }
                    }
                    
                    polygonCoordinates.append(pointWithLowestTangens)
                    lastAddedPoint = pointWithLowestTangens
                    lowestTangens = 99999
                    
                }
            }
            
            lowestTangens = 99999
            noMoreAttempts = false
            
            // Go west until we reach the westmost point (first point)
            while pointWithLowestTangens.longitude != westPoint.longitude && pointWithLowestTangens.latitude != westPoint.latitude {
                if noMoreAttempts == false {
                    numberOfAttempts = 0
                    for coord in coordinates {
                        
                        // If it's going south
                        if coord.latitude < lastAddedPoint.latitude {
                            if (lastAddedPoint.longitude - coord.longitude)/(lastAddedPoint.latitude - coord.latitude) < lowestTangens {
                                lowestTangens = (coord.longitude - lastAddedPoint.longitude)/(coord.latitude - lastAddedPoint.latitude)
                                pointWithLowestTangens = coord
                            }
                        } else {
                            numberOfAttempts += 1 //number of North coords
                            if numberOfAttempts == coordinates.count-1 {
                                noMoreAttempts = true
                            }
                        }
                    }
                    if pointWithLowestTangens.latitude != 0 {
                        polygonCoordinates.append(pointWithLowestTangens)
                        lastAddedPoint = pointWithLowestTangens
                    }
                    lowestTangens = 99999
                } else {
                    numberOfAttempts = 0
                    for coord in coordinates {
                        
                        // If it's going north
                        if coord.latitude > lastAddedPoint.latitude && coord.longitude < lastAddedPoint.longitude {
                            if (coord.latitude - lastAddedPoint.latitude)/(lastAddedPoint.longitude - coord.longitude) < lowestTangens {
                                lowestTangens = (coord.latitude - lastAddedPoint.latitude)/(lastAddedPoint.longitude - coord.longitude)
                                pointWithLowestTangens = coord
                            } else {
                                numberOfAttempts += 1
                                if numberOfAttempts == coordinates.count-1 {
                                    pointWithLowestTangens = westPoint
                                }
                            }
                        }
                    }
                    polygonCoordinates.append(pointWithLowestTangens)
                    lastAddedPoint = pointWithLowestTangens
                    lowestTangens = 99999
                }
            }
            
            if !polygonCoordinates.isEmpty {
                print("Created a polygon \(polygonCoordinates.count) points")
                let polygon = MKPolygon.init(coordinates: &polygonCoordinates, count: polygonCoordinates.count)
                return polygon
            }
        }
        return nil
    }
}

class MapController: NSObject {
    
    //MARK:- Actions
    @objc func showUserLocationClick(sender: UIButton!) {
        guard let map = map else { return }
        map.userTrackingMode = .follow
    }
    
    @objc func showPinClick(sender: UIButton!) {
//        setMapCenter()
    }
    
    //MARK:- Properties
    weak var vc: UIViewController?
    var mapContainer: UIView
    var map: MKMapView?
    var centerButton: UIButton?
    var showPinButton: UIButton?
    let lm = CLLocationManager()
    var coordinates: [CLLocationCoordinate2D]
    var mapHasContent = false
    
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
        
        // Add markers
        for coordinate in coordinates.enumerated() {
            addMarker(title: "Marker number \(coordinate.offset)", coordinate: coordinate.element)
        }
        
        // Add buttons
        addCenterButton()
        if mapHasContent {
            addShowPinButton()
        }
    }
    
    func addCenterButton() {
        centerButton = UIButton(frame: CGRect(x: mapContainer.frame.maxX - 60, y: mapContainer.frame.maxY - 80, width: 50, height: 50))
        guard let centerButton = centerButton else { return }
        mapContainer.addSubview(centerButton)
//        NSLayoutConstraint.activate([centerButton.trailingAnchor.constraint(equalTo: map.trailingAnchor, constant: -10),
//                                     centerButton.bottomAnchor.constraint(equalTo: map.bottomAnchor, constant: -20),
//                                     centerButton.heightAnchor.constraint(equalToConstant: 40),
//                                     centerButton.widthAnchor.constraint(equalToConstant: 40)
//            ])
//        centerButton.translatesAutoresizingMaskIntoConstraints = false
//        centerButton.setImage(#imageLiteral(resourceName: ""), for: UIControl.State.normal)
        centerButton.backgroundColor = .white
        centerButton.layer.cornerRadius = 25
        //        centerButton.layer.borderColor = .black
        //        centerButton.layer.borderWidth = 1
        centerButton.addTarget(self, action: #selector(showUserLocationClick), for: .touchUpInside)
        centerButton.layer.shadowColor = UIColor.black.cgColor
        centerButton.layer.shadowOffset = CGSize(width: 0, height: -1)
        centerButton.layer.shadowOpacity = 0.2
        centerButton.layer.shadowRadius = 1
    }
    
    func addShowPinButton() {
        showPinButton = UIButton(frame: CGRect(x: mapContainer.frame.maxX - 110, y: mapContainer.frame.maxY - 80, width: 50, height: 50))
        guard let showPinButton = showPinButton else { return }
        mapContainer.addSubview(showPinButton)
//        NSLayoutConstraint.activate([bt.trailingAnchor.constraint(equalTo: map.trailingAnchor, constant: -60),
//                                     bt.bottomAnchor.constraint(equalTo: map.bottomAnchor, constant: -20),
//                                     bt.heightAnchor.constraint(equalToConstant: 40),
//                                     bt.widthAnchor.constraint(equalToConstant: 40)
//            ])
//        bt.translatesAutoresizingMaskIntoConstraints = false
//        showPinButton.setImage(#imageLiteral(resourceName: ""), for: UIControl.State.normal)
        showPinButton.backgroundColor = .white
        showPinButton.layer.cornerRadius = 25
        //            bt.layer.borderColor = .black
        //            bt.layer.borderWidth = 1
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
    }
    
//    func setMapCenter(){
//        if mapHasContent {
//            guard let map = map else { return }
//            var region = map.region
//            region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
//            region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
//            region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.5;
//            region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.5;
            
            
//            _ = setTimeout(0.5, block: {
//                self.map.setRegion(region, animated: true)
//            })
//        }
//    }
    
//    func  clearCoordinatesAndMap() {
//        topLeftCoord = CLLocationCoordinate2D(latitude:-90, longitude:  180)
//        bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
//
//        for annot in map.annotations {
//            map.removeAnnotation(annot)
//        }
//        for overlay in map.overlays {
//            map.remove(overlay)
//        }
//    }
}

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3
            return renderer
        } else {
            return MKOverlayRenderer()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annot = annotation as? MKPointAnnotation {
            let annotationIdentifier = "AnnotationIdentifier"
            let annotationView = MKAnnotationView(annotation: annot, reuseIdentifier: annotationIdentifier)
            annotationView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            annotationView.centerOffset = CGPoint(x: 0, y: -50/2)
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//            imageView.image = #imageLiteral(resourceName: "mapPoint")
            imageView.backgroundColor = .white
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            annotationView.addSubview(imageView)
            annotationView.isDraggable = false
            annotationView.canShowCallout = true
            return annotationView
        } else {
            return nil
        }
    }
}

