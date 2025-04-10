//
//  PlaceAnnotation.swift
//  BusyBrew
//
//  Created by Thomas Moody on 3/10/25.
//

import Foundation
import MapKit

class PlaceAnnotation: MKPointAnnotation {
    
    let mapItem: MKMapItem
    let id = UUID()
    var isSelected: Bool = false
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
        super.init()
        self.coordinate = mapItem.placemark.coordinate
        self.title = mapItem.name
    }
    
    var name: String {
        mapItem.name ?? ""
    }
    
    var phone: String? {
        mapItem.phoneNumber ?? ""
    }
    
    var address: String {
        "\(mapItem.placemark.subThoroughfare ?? "") \(mapItem.placemark.thoroughfare ?? ""), \(mapItem.placemark.locality ?? "")"
    }
    
    var location: CLLocation {
        mapItem.placemark.location ?? CLLocation.default
    }
    
    var placeId: String {
        let name = self.name.replacingOccurrences(of: " ", with: "+")
        let lat = self.location.coordinate.latitude
        let long = self.location.coordinate.longitude
        return "\(name)-\(lat)-\(long)"
        
    }
}
