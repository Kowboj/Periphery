import UIKit

class CoordinatesCell: UITableViewCell {
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "AmericanTypewriter", size: 18)
        return label
    }()
    
    lazy var latLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "AmericanTypewriter", size: 15)
        return label
    }()
    
    lazy var lonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "AmericanTypewriter", size: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewHierarchy()
        setupProperties()
        setupLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewHierarchy() {
        [numberLabel, latLabel, lonLabel].forEach(addSubview)
    }
    
    func setupProperties() {
        backgroundColor = UIColor.init(red: 99/100, green: 9/10, blue: 8/10, alpha: 1)
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    func setupLayoutConstraints() {
        numberLabel.anchor(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5), size: CGSize(width: 20, height: 0))
        
        latLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: -25), size: CGSize(width: 0, height: 0.5 * frame.height))
        
        lonLabel.anchor(top: latLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: -25), size: .zero)
    }
}

extension CoordinatesCell: Reusable {}
