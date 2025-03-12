//
//  HomeViewController.swift
//  BusyBrew
//
//  Created by Thomas Moody on 3/9/25.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, MKMapViewDelegate {
    
    var locationManager: CLLocationManager?
    private var places: [PlaceAnnotation] = []
    let menuSegueIdentifier = "MenuSegue"
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 10
        searchTextField.delegate = self
        searchTextField.clipsToBounds = true
        searchTextField.backgroundColor = UIColor.white
        searchTextField.placeholder = "Search"
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    lazy var menuButton: UIButton = {
        let menuButton = UIButton(type: .custom)
        menuButton.backgroundColor = background1Light
        menuButton.setTitleColor(.white, for: .normal)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.layer.cornerRadius = 5
        menuButton.setImage(UIImage(named: "Grid.svg"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonClicked), for: .touchUpInside)
        return menuButton
    }()
    
    @objc func menuButtonClicked() {
        performSegue(withIdentifier: menuSegueIdentifier, sender: self)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
//        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization() // for use in background
        print("Requesting location")
        locationManager?.requestLocation()
        locationManager?.startUpdatingLocation()
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(mapView)
        view.addSubview(menuButton)
        view.bringSubviewToFront(searchTextField)
        
        // search text field constraints
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        searchTextField.returnKeyType = .go
        searchTextField.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: -20).isActive = true
        
        // menu button constraints
        menuButton.topAnchor.constraint(equalTo: searchTextField.topAnchor).isActive = true
        menuButton.heightAnchor.constraint(equalTo: searchTextField.heightAnchor).isActive = true
        menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        
        
        // map view contraints
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // check if user allowed access to location
    private func checkLocationAuthorizatation() {
        guard let locationManager = locationManager,
              let location = locationManager.location else {return}
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mapView.setRegion(region, animated: true)
            print("Location access authorized.")
        case .denied:
            print("Location services has been denied.")
        case .notDetermined, .restricted:
            print("Location cannot be determined or restricted.")
        @unknown default:
            print("Uknown error. Unable to get location.")
        }
    }
    
    // display table listing nearby places
    private func presentPlacesSheet(places: [PlaceAnnotation]) {
        
        guard let locationManager = locationManager,
          let userLocation = locationManager.location else {return}
        
        let placesTVC = PlacesTableViewController(userLocation: userLocation, places: places)
        placesTVC.modalPresentationStyle = .pageSheet
        
        if let sheet = placesTVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesTVC, animated: true)
        }
    }
    
    private func findNearbyPlaces(by query: String) {
        // clear any annotations
       
        mapView.removeAnnotations(mapView.annotations)
        
        print("Requesting search...")
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        request.pointOfInterestFilter = .init(including: [.cafe])
        print("Requesting completed")
        
        print("Searching for places...")
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response, error == nil else { return }
            
            self?.places = response.mapItems.map(PlaceAnnotation.init)
            self?.places.forEach {place in
                self?.mapView.addAnnotation(place)}
            
            if let places = self?.places {
                print("Presenting...")
                self?.presentPlacesSheet(places: places)
                print("Presenting Completed...")
            }
        }
    }
    
    // MKMapViewDelegate conform functions
    
    private func clearAllSelections() {
        self.places = self.places.map {
            place in place.isSelected = false
            return place
        }
    }
    
    // highlight place in table when selected on map
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        
        // clear other selections
        clearAllSelections()
        
        guard let selectionAnnotation = annotation as? PlaceAnnotation else { return }
        let placeAnnotation = self.places.first(where: {$0.id == selectionAnnotation.id })
        placeAnnotation?.isSelected = true
        
        presentPlacesSheet(places: self.places)
    }
    
    // set markers to show coffee cup
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlaceAnnotation else { return nil }
        
        var view: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "PlaceAnnotation") as? MKMarkerAnnotationView
        if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PlaceAnnotation")
            view?.canShowCallout = true
        } else {
            view?.annotation = annotation
        }
            view?.glyphImage = UIImage(systemName: "cup.and.saucer.fill")
            
            // add label showing name of place
            let label = UILabel()
            label.text = annotation.name
            label.numberOfLines = 1
            view?.detailCalloutAccessoryView = label
            
        
        return view
    }
    
    
    // CLLocationManagerDelegate conform functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
           
           let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
           mapView.setRegion(region, animated: true)
        
        // Wait for map to finish zooming so it only show nearby coffee shops. I'm not sure if this is the best way to do this or a temporary solution but right now its just delaying the findyNearbyPlaces call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Automatically display coffee shops when map opened
                self.findNearbyPlaces(by: "Coffee")
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizatation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    // UITextFieldDelegate conform functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            // find nearby cafes
            findNearbyPlaces(by: text)
        }
        return true
    }
    

}
