//
//  CoordinatesCell.swift
//  Periphery
//
//  Created by NoGravity DEV on 11.10.2018.
//  Copyright © 2018 Kowboj. All rights reserved.
//

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
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: topAnchor),
            numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            numberLabel.widthAnchor.constraint(equalToConstant: 20),
            numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            latLabel.topAnchor.constraint(equalTo: topAnchor),
            latLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            latLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            latLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            lonLabel.topAnchor.constraint(equalTo: latLabel.bottomAnchor),
            lonLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            lonLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            lonLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
    }
}

extension CoordinatesCell: Reusable {}
