//
//  PlaceDetailController.swift
//  BusyBrew
//
//  Created by Thomas Moody on 3/10/25.
//

import Foundation
import UIKit

class PlaceDetailViewController: UIViewController {
    let place: PlaceAnnotation
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.alpha = 0.4
        return label
    }()
    
    var directionsButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Directions", for: .normal)
        return button
    }()
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder has not been implemented")
    }
    
    // Open Apple Maps when pressed
    @objc func directionsButtonTapped(_ sender: UIButton) {
        let coordinate = place.location.coordinate
        guard let url = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") else {
            print("Error opening Apple Maps")
            return
        }
       
        UIApplication.shared.open(url)
    }
    
    private func setupUI() {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseDefault
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        nameLabel.text = place.name
        addressLabel.text = place.address
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        
        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        
        // Add contact buttons as individual stackview
        let contactStackView = UIStackView()
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.axis = .horizontal // place buttons side by side horizontally
        contactStackView.spacing = UIStackView.spacingUseSystem
        
        
        directionsButton.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        
        contactStackView.addArrangedSubview(directionsButton)
        
        stackView.addArrangedSubview(contactStackView)
        view.addSubview(stackView)
    }
}
