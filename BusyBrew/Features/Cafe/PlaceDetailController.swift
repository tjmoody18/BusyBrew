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
    let currentStatus = "MODERATELY BUSY"
    let rating = 5.0
    let categories = ["wifi quality", "cleanliness", "outlets availability"]
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        return label
    }()
    
    lazy var favButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.alpha = 0.4
        label.numberOfLines = 1
        return label
    }()
    
    lazy var directionsButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Directions", for: .normal)
        button.backgroundColor = background1Light
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var cafeImage: UIImageView = {
        let cafeImage = UIImageView()
        cafeImage.image = UIImage(named: "cafe.png")
        cafeImage.contentMode = .scaleAspectFill
        cafeImage.translatesAutoresizingMaskIntoConstraints = false
        return cafeImage
    }()
    
    lazy var reportStatusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = background4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    lazy var overallRating: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 64, weight: .bold)
        label.textColor = background1
        return label
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
        view.backgroundColor = background3
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let topSection = UIView()
        topSection.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: -2.0  // reduce the letter spacing
        ]
        
        let lesserSpacing: [NSAttributedString.Key: Any] = [
            .kern: -1.0  // reduce the letter spacing
        ]
        nameLabel.attributedText = NSAttributedString(string: place.name, attributes: attributes)
        addressLabel.text = place.address
        
        let contactStackView = UIStackView()
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.axis = .horizontal
        contactStackView.spacing = UIStackView.spacingUseSystem
        
        contactStackView.addArrangedSubview(addressLabel)
        contactStackView.addArrangedSubview(directionsButton)
        
        directionsButton.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        
        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        statusLabel.attributedText = NSAttributedString(string: "current status:", attributes: lesserSpacing)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let status = UILabel()
        status.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        status.attributedText = NSAttributedString(string: currentStatus, attributes: lesserSpacing)
        status.translatesAutoresizingMaskIntoConstraints = false
        status.textColor = background2
        
        let ratingView = UIView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        let ratingLabel = UILabel()
        ratingLabel.attributedText = NSAttributedString(string: "overall", attributes: lesserSpacing)
        ratingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        reportStatusButton.setTitle("Report Status", for: .normal)
        
        overallRating.attributedText = NSAttributedString(string: String(rating), attributes: attributes)
        
        ratingView.addSubview(ratingLabel)
        ratingView.addSubview(overallRating)
        
        let detailedRatingView = UIView()
        detailedRatingView.translatesAutoresizingMaskIntoConstraints = false
        detailedRatingView.backgroundColor = .white
        detailedRatingView.layer.cornerRadius = 5
        
        let detailedContentView = UIView()
        detailedContentView.translatesAutoresizingMaskIntoConstraints = false
        detailedRatingView.addSubview(detailedContentView)
        
        var lastLabel: UILabel? = nil
        for category in categories {
            let labelView = UIView()
            labelView.translatesAutoresizingMaskIntoConstraints = false
            let label = UILabel()
            label.attributedText = NSAttributedString(string: category, attributes: lesserSpacing)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = background4
            label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
            let score = UILabel()
            score.attributedText = NSAttributedString(string: "5/5", attributes: lesserSpacing)
            score.translatesAutoresizingMaskIntoConstraints = false
            score.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            
            detailedContentView.addSubview(labelView)
            labelView.addSubview(label)
            labelView.addSubview(score)
            
            NSLayoutConstraint.activate([
                labelView.leadingAnchor.constraint(equalTo: detailedContentView.leadingAnchor),
                labelView.trailingAnchor.constraint(equalTo: detailedContentView.trailingAnchor),
                
                score.topAnchor.constraint(equalTo: label.bottomAnchor, constant: -1)
            ])
            
            if let lastLabel = lastLabel {
                labelView.topAnchor.constraint(equalTo: lastLabel.bottomAnchor, constant: 10).isActive = true
            } else {
                labelView.topAnchor.constraint(equalTo: detailedContentView.topAnchor).isActive = true
            }
            
            lastLabel = score
            
        }
        
        
        // Constraints
        scrollView.addSubview(topSection)
        NSLayoutConstraint.activate([
            topSection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            topSection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            topSection.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50)
        ])
        
        topSection.addSubview(nameLabel)
        topSection.addSubview(favButton)
        topSection.addSubview(contactStackView)
        topSection.addSubview(cafeImage)
        topSection.addSubview(statusLabel)
        topSection.addSubview(status)
        topSection.addSubview(reportStatusButton)
        topSection.addSubview(ratingView)
        topSection.addSubview(detailedRatingView)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topSection.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: topSection.leadingAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 240)
        ])
        
        NSLayoutConstraint.activate([
            favButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            favButton.trailingAnchor.constraint(equalTo: topSection.trailingAnchor),
            favButton.widthAnchor.constraint(equalToConstant: 20),
            favButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            contactStackView.leadingAnchor.constraint(equalTo: topSection.leadingAnchor),
            contactStackView.trailingAnchor.constraint(equalTo: topSection.trailingAnchor),
            contactStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            cafeImage.leadingAnchor.constraint(equalTo: topSection.leadingAnchor),
            cafeImage.trailingAnchor.constraint(equalTo: topSection.trailingAnchor),
            cafeImage.topAnchor.constraint(equalTo: contactStackView.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: topSection.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: cafeImage.bottomAnchor, constant: 15),
            
            status.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor),
            status.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 5),
            
            reportStatusButton.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 10),
            reportStatusButton.leadingAnchor.constraint(equalTo: topSection.leadingAnchor),
            reportStatusButton.trailingAnchor.constraint(equalTo: topSection.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: topSection.leadingAnchor),
            ratingView.topAnchor.constraint(equalTo: reportStatusButton.bottomAnchor, constant: 15),
            
            overallRating.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 1),
            
            detailedRatingView.topAnchor.constraint(equalTo: ratingView.topAnchor),
            detailedRatingView.trailingAnchor.constraint(equalTo: topSection.trailingAnchor),
            detailedRatingView.widthAnchor.constraint(equalToConstant: 160),
            detailedRatingView.heightAnchor.constraint(equalToConstant: 180),
            
            detailedContentView.bottomAnchor.constraint(equalTo: detailedRatingView.bottomAnchor, constant: -15),
            detailedContentView.leadingAnchor.constraint(equalTo: detailedRatingView.leadingAnchor, constant: 15),
            detailedContentView.topAnchor.constraint(equalTo: detailedRatingView.topAnchor, constant: 15),
            detailedContentView.trailingAnchor.constraint(equalTo: detailedRatingView.trailingAnchor, constant: -15),
        ])
    }
}
