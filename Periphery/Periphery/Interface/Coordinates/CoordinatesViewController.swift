import UIKit
import MapKit

final class CoordinatesViewController: UIViewController {
    
    // MARK: - Actions
    @objc func addClick() {
        let latTextField = coordinatesView.latTextField.text ?? ""
        let lonTextField = coordinatesView.lonTextField.text ?? ""
        if latTextField.isEmpty || lonTextField.isEmpty {
            coordinatesView.infoLabel.text = "Please fill coordinate to continue"
        } else {
            coordinatesView.infoLabel.text = nil
            var lat = NSString(string: latTextField).doubleValue
            var lon = NSString(string: lonTextField).doubleValue
            if abs(lat) > 90 || abs(lon) > 180 {
                coordinatesView.infoLabel.text = "Please use real values"
            } else {
                if coordinatesView.latSegmented.selectedSegmentIndex == 1 { // S
                    lat *= -1
                }
                if coordinatesView.lonSegmented.selectedSegmentIndex == 0 { // W
                    lon *= -1
                }
                coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
                coordinatesView.tableView.reloadData()
            }
        }
    }
    
    @objc func showMapClick() {
        if coordinates.count < 3 {
            coordinatesView.infoLabel.text = "You need at least 3 coordinates"
        } else {
            let mapViewController = MapViewController(coordinates: coordinates)
            navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
    
    @objc func generateRandomClick() {
        guard let randomNumberText = coordinatesView.randomNumberTextField.text else { return }
        let numberOfRandom = NSString(string: randomNumberText).intValue
        for _ in 0..<numberOfRandom {
            let randomLat = CLLocationDegrees.init(exactly: Float.random(in: 50...51))
            let randomLon = CLLocationDegrees.init(exactly: Float.random(in: 21...22))
            coordinates.append(CLLocationCoordinate2D(latitude: randomLat!, longitude: randomLon!))
        }
        coordinatesView.tableView.reloadData()
    }
    
    @objc func clearClick() {
        coordinates.removeAll()
        coordinatesView.tableView.reloadData()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Properties
    private let coordinatesView = CoordinatesView()
    private var coordinates = [CLLocationCoordinate2D]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = coordinatesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupProperties()
    }
    
    func setupNavigationItem() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 44))
        label.backgroundColor = .clear
        label.font = UIFont(name: "AmericanTypewriter", size: 14)
        label.textAlignment = .center
        label.text = "Periphery"
        navigationItem.titleView = label
    }
    
    func setupProperties() {
        coordinatesView.tableView.dataSource = self
        coordinatesView.tableView.delegate = self
        coordinatesView.tableView.register(CoordinatesCell.self, forCellReuseIdentifier: CoordinatesCell.reuseIdentifier)
        
        // Add add coordinates action
        coordinatesView.addButton.addTarget(self, action: #selector(addClick), for: UIControl.Event.touchUpInside)
        
        // Add show map action
        coordinatesView.showMapButton.addTarget(self, action: #selector(showMapClick), for: UIControl.Event.touchUpInside)
        
        // Add generate random action
        coordinatesView.randomButton.addTarget(self, action: #selector(generateRandomClick), for: UIControl.Event.touchUpInside)
        
        // Add clear action
        coordinatesView.clearButton.addTarget(self, action: #selector(clearClick), for: UIControl.Event.touchUpInside)
        
        // Add keyboard hiding action
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        coordinatesView.addGestureRecognizer(tap)
    }
}

extension CoordinatesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coordinates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CoordinatesCell.reuseIdentifier) as? CoordinatesCell {
            let currentCoordinate = coordinates[indexPath.row]
            cell.latLabel.text = "lat: \(currentCoordinate.latitude)"
            cell.lonLabel.text = "lon: \(currentCoordinate.longitude)"
            cell.numberLabel.text = "\(indexPath.row+1)"
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        coordinates.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
}
