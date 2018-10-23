//
//  PeripheryTests.swift
//  PeripheryTests
//
//  Created by NoGravity DEV on 12.10.2018.
//  Copyright © 2018 Kowboj. All rights reserved.
//

import XCTest
import MapKit
@testable import Periphery

final class PolygonTest: XCTestCase {

    var sut: PolygonCreator!
    var coordinates = [CLLocationCoordinate2D]()
    var numberOfRandomCoordinates = 50
    
    override func setUp() {
        super.setUp()
        sut = PolygonCreator()
        for _ in 0...numberOfRandomCoordinates {
            let randomLat = CLLocationDegrees.init(exactly: Float.random(in: 50...51))
            let randomLon = CLLocationDegrees.init(exactly: Float.random(in: 21...22))
            coordinates.append(CLLocationCoordinate2D(latitude: randomLat!, longitude: randomLon!))
        }
    }
    
    func testOutputCoordinatesCount() {
        if let polygon = sut.createPolygon(coordinates: coordinates) {
            var outsidePoints = 0
            for coord in coordinates {
                if !polygon.boundingMapRect.contains(MKMapPoint(coord)) {
                    outsidePoints += 1
                }
            }
            XCTAssertEqual(outsidePoints, 0)
        }
        
    }
}
