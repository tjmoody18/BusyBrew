//
//  PlacesTableViewController.swift
//  BusyBrew
//
//  Created by Thomas Moody on 3/10/25.
//

import Foundation
import UIKit
import MapKit

class PlacesTableViewController: UITableViewController {
    
    var userLocation: CLLocation
    let places: [PlaceAnnotation]
    
    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil , bundle: nil)
        
        // add cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    private func calculateDistance(from: CLLocation, to: CLLocation) -> CLLocationDistance {
        from.distance(from: to)
    }
    
    private func formatDistanceForDisplay(_ distance: CLLocationDistance) -> String {
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to: .miles).formatted()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let place = places[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = formatDistanceForDisplay(calculateDistance(from: userLocation, to: place.location))
        
        cell.contentConfiguration = content
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
