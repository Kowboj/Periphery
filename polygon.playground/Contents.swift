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

