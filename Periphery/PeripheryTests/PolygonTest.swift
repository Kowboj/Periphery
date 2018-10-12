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
    
    override func setUp() {
        super.setUp()
        sut = PolygonCreator()
        for _ in 0...7 {
            let randomLat = CLLocationDegrees.init(exactly: Float.random(in: 50...51))
            let randomLon = CLLocationDegrees.init(exactly: Float.random(in: 21...22))
            coordinates.append(CLLocationCoordinate2D(latitude: randomLat!, longitude: randomLon!))
        }
    }
    
    func testOutputCoordinatesCount() {
        let polygon = sut.createPolygon(coordinates: coordinates)
//        for coord in coordinates {
//            print(coord.latitude, coord.longitude)
//        }
        XCTAssertEqual(polygon!.pointCount, coordinates.count)
    }
}
