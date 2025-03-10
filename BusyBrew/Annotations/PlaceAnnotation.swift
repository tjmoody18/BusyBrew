//
//  PlaceAnnotation.swift
//  BusyBrew
//
//  Created by Thomas Moody on 3/10/25.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    var location: CLLocation
    var coordinate: CLLocationCoordinate2D
    var name: String?
    
    init(mapItem: MKMapItem) {
        self.name = mapItem.name
        self.location = mapItem.placemark.location!
        self.coordinate = mapItem.placemark.coordinate
    }
}
