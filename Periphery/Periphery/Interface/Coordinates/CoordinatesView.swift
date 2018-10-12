import UIKit

final class CoordinatesView: UIView {
    
    private(set) lazy var latSegmented: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["N", "S"])
        segmented.selectedSegmentIndex = 0
        segmented.tintColor = .white
        segmented.translatesAutoresizingMaskIntoConstraints = false
        return segmented
    }()
    
    private(set) lazy var lonSegmented: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["W", "E"])
        segmented.selectedSegmentIndex = 1
        segmented.tintColor = .white
        segmented.translatesAutoresizingMaskIntoConstraints = false
        return segmented
    }()
    
    private(set) lazy var latTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = UIKeyboardType.decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.placeholder = "latitude"
        textField.font = UIFont(name: "AmericanTypewriter", size: 12)
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private(set) lazy var lonTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = UIKeyboardType.decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.placeholder = "longitude"
        textField.font = UIFont(name: "AmericanTypewriter", size: 12)
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private(set) lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "AmericanTypewriter", size: 12)
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add coordinate", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: "AmericanTypewriter", size: 12)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.init(red: 0, green: 0.3, blue: 0.3, alpha: 1)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    private(set) lazy var showMapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show map", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: "AmericanTypewriter", size: 12)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupViewHierarchy()
        setupProperties()
        setupLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViewHierarchy() {
        [latTextField, lonTextField, latSegmented, lonSegmented, infoLabel, addButton, tableView, showMapButton].forEach(addSubview)
    }
    
    fileprivate func setupProperties() {
        backgroundColor = UIColor.init(red: 0, green: 0.3, blue: 0.3, alpha: 1)
    }
    
    fileprivate func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            latTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            latTextField.topAnchor.constraint(equalTo: topAnchor, constant: 84),
            latTextField.heightAnchor.constraint(equalToConstant: 30),
            latTextField.widthAnchor.constraint(equalToConstant: 130),
            
            lonTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            lonTextField.topAnchor.constraint(equalTo: latTextField.bottomAnchor, constant: 20),
            lonTextField.heightAnchor.constraint(equalToConstant: 30),
            lonTextField.widthAnchor.constraint(equalToConstant: 130),
            
            latSegmented.trailingAnchor.constraint(equalTo: latTextField.leadingAnchor, constant: -20),
            latSegmented.centerYAnchor.constraint(equalTo: latTextField.centerYAnchor),
            latSegmented.heightAnchor.constraint(equalToConstant: 30),
            latSegmented.widthAnchor.constraint(equalToConstant: 80),

            lonSegmented.trailingAnchor.constraint(equalTo: lonTextField.leadingAnchor, constant: -20),
            lonSegmented.centerYAnchor.constraint(equalTo: lonTextField.centerYAnchor),
            lonSegmented.heightAnchor.constraint(equalToConstant: 30),
            lonSegmented.widthAnchor.constraint(equalToConstant: 80),
            
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: lonTextField.bottomAnchor, constant: 20),
            infoLabel.heightAnchor.constraint(equalToConstant: 40),
            infoLabel.widthAnchor.constraint(equalToConstant: 250),
            
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.widthAnchor.constraint(equalToConstant: 120),
            
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            tableView.bottomAnchor.constraint(equalTo: showMapButton.topAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            
            showMapButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            showMapButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            showMapButton.heightAnchor.constraint(equalToConstant: 30),
            showMapButton.widthAnchor.constraint(equalToConstant: 120),
            showMapButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
            ])
    }
}
