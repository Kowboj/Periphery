import UIKit
import MapKit

enum Direction {
    case NE
    case SE
    case SW
    case NW
}

class PolygonCreator {
    
    // It's the final array containing coordinates in the proper order
    var polygonCoordinates = [CLLocationCoordinate2D]()
    var lowestTangens: Double = Double.infinity // as maximum tangens is infinity
    
    func createPolygon(coordinates: [CLLocationCoordinate2D]) -> MKPolygon? {
        
        if coordinates.count <= 2 {
            print("Need at least 3 coordinates")
            return nil
            
        } else if coordinates.count > 2 {
            
            let edgePoints = findWestAndEastMostPoint(coordinates: coordinates)
            let westPoint = edgePoints.westPoint
            let eastPoint = edgePoints.eastPoint
            
            // Begin with the westmost point
            polygonCoordinates.append(westPoint)
            var lastAddedPoint = westPoint
            
            // What is it all about? Search for a point with the lowest tangens
            var pointWithLowestTangens = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            
            // If no coords in NE direction, try SE, SW, and finally NW
            var numberOfAttempts = 0
            var noMoreAttempts = false
            
            // Until it bumps into the eastmost point
            while pointWithLowestTangens != eastPoint {
                if !noMoreAttempts {
                    for coord in coordinates {
                        // NE
                        if checkDirection(from: lastAddedPoint, to: coord, direction: .NE), let newLowestTangens = returnTangensIfLowest(from: lastAddedPoint, coord: coord, direction: .NE) {
                            lowestTangens = newLowestTangens
                            pointWithLowestTangens = coord
                        } else {
                            numberOfAttempts += 1
                            if numberOfAttempts == coordinates.count {
                                noMoreAttempts = true
                            }
                        }
                    }
                    if !polygonCoordinates.contains(pointWithLowestTangens) && pointWithLowestTangens != CLLocationCoordinate2D(latitude: -90, longitude: 180) {
                        polygonCoordinates.append(pointWithLowestTangens)
                        lastAddedPoint = pointWithLowestTangens
                    }
                    numberOfAttempts = 0
                    lowestTangens = Double.infinity
                } else {
                    for coord in coordinates {
                        // SE
                        if checkDirection(from: lastAddedPoint, to: coord, direction: .SE), let newLowestTangens = returnTangensIfLowest(from: lastAddedPoint, coord: coord, direction: .SE) {
                            lowestTangens = newLowestTangens
                            pointWithLowestTangens = coord
                        }
                    }
                    if !polygonCoordinates.contains(pointWithLowestTangens) {
                        polygonCoordinates.append(pointWithLowestTangens)
                        lastAddedPoint = pointWithLowestTangens
                    }
                    lowestTangens = Double.infinity
                }
            }
            noMoreAttempts = false
            
            // Until it closes the polygon bumping into the first, westmost point
            while pointWithLowestTangens != westPoint {
                if !noMoreAttempts {
                    for coord in coordinates {
                        // SW
                        if checkDirection(from: lastAddedPoint, to: coord, direction: .SW), let newLowestTangens = returnTangensIfLowest(from: lastAddedPoint, coord: coord, direction: .SW) {
                            lowestTangens = newLowestTangens
                            pointWithLowestTangens = coord
                        } else {
                            numberOfAttempts += 1
                            if numberOfAttempts == coordinates.count {
                                noMoreAttempts = true
                            }
                        }
                    }
                    if pointWithLowestTangens.latitude != 0 {
                        if !polygonCoordinates.contains(pointWithLowestTangens) {
                            polygonCoordinates.append(pointWithLowestTangens)
                            lastAddedPoint = pointWithLowestTangens
                        }
                    }
                    numberOfAttempts = 0
                    lowestTangens = Double.infinity
                } else {
                    for coord in coordinates {
                        // NW
                        if checkDirection(from: lastAddedPoint, to: coord, direction: .NW), let newLowestTangens = returnTangensIfLowest(from: lastAddedPoint, coord: coord, direction: .NW) {
                            lowestTangens = newLowestTangens
                            pointWithLowestTangens = coord
                        } else {
                            numberOfAttempts += 1
                            if numberOfAttempts == coordinates.count {
                                pointWithLowestTangens = westPoint
                            }
                        }
                    }
                    polygonCoordinates.append(pointWithLowestTangens)
                    lastAddedPoint = pointWithLowestTangens
                    lowestTangens = Double.infinity
                }
            }
        
            if polygonCoordinates.count > 2 {
                print("Created a polygon from \(polygonCoordinates.count) points, \(coordinates.count - polygonCoordinates.count) points left hopefully inside")
                let polygon = MKPolygon.init(coordinates: &polygonCoordinates, count: polygonCoordinates.count)
                return polygon
            } else {
                print("Can't create polygon")
            }
        }
        return nil
    }
    
    func findWestAndEastMostPoint(coordinates: [CLLocationCoordinate2D]) -> (westPoint: CLLocationCoordinate2D, eastPoint: CLLocationCoordinate2D) {
        var westPoint = CLLocationCoordinate2DMake(CLLocationDegrees(-90), CLLocationDegrees(180))
        var eastPoint = CLLocationCoordinate2DMake(CLLocationDegrees(-90), CLLocationDegrees(-180))
        
        // Get westmost and eastmost points
        for coordinate in coordinates {
            if coordinate.longitude < westPoint.longitude {
                westPoint = coordinate
            } else if coordinate.longitude == westPoint.longitude {
                if coordinate.latitude > westPoint.latitude {
                    westPoint = coordinate
                }
            }
            if coordinate.longitude > eastPoint.longitude {
                eastPoint = coordinate
            } else if coordinate.longitude == eastPoint.longitude {
                if coordinate.latitude < eastPoint.latitude {
                    eastPoint = coordinate
                }
            }
        }
        return (westPoint, eastPoint)
    }
    
    func checkDirection(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, direction: Direction) -> Bool {
        switch direction {
        case .NE:
            if to.longitude > from.longitude && to.latitude >= from.latitude {
                return true } else { return false }
        case .SE:
            if from.latitude > to.latitude && to.longitude >= from.longitude {
                return true } else { return false }
        case .SW:
            if to.latitude <= from.latitude && to.longitude < from.longitude {
                return true } else { return false }
        case .NW:
            if to.latitude > from.latitude && to.longitude <= from.longitude {
                return true } else { return false }
        }
    }
    
    func returnTangensIfLowest(from: CLLocationCoordinate2D, coord: CLLocationCoordinate2D, direction: Direction) -> Double? {
        var tangens: Double
        switch direction {
        case .NE: // fmin(dx/dy)
            tangens = (coord.longitude - from.longitude)/(coord.latitude - from.latitude)
        case .SE: // fmin(dy/dx)
            tangens = (from.latitude - coord.latitude)/(coord.longitude - from.longitude)
        case .SW: // fmin(dx/dy)
            tangens = (from.longitude - coord.longitude)/(from.latitude - coord.latitude)
        case .NW: // fmin(dy/dx)
            tangens = (coord.latitude - from.latitude)/(from.longitude - coord.longitude)
        }
        if tangens < lowestTangens {
            return tangens
        } else if tangens == Double.infinity && lowestTangens == Double.infinity {
            // if it's in one line (dx == 0 || dy == 0) and haven't found any better way
            return tangens
        } else { return nil }
    }
}
