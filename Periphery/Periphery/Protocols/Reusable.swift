//
//  Reusable.swift
//  Periphery
//
//  Created by NoGravity DEV on 11.10.2018.
//  Copyright © 2018 Kowboj. All rights reserved.
//

import Foundation

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
