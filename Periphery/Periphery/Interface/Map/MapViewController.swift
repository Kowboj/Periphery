import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    let mapView = MapView()
    var coordinates: [CLLocationCoordinate2D]
    var map: MapController!
    
    init(coordinates: [CLLocationCoordinate2D]) {
        self.coordinates = coordinates
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map = MapController(vc: self, mapContainer: view, coordinates: self.coordinates)
    }
}
