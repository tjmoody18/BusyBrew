//
//  PlaceDetailController.swift
//  BusyBrew
//
//  Created by Thomas Moody on 3/10/25.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class PlaceDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var user: User?
    var isFavorite: Bool = false
    var cafe: Cafe?
    //    var currentStatus: String
    let place: PlaceAnnotation
    var rating = 5.0
    let categories = ["wifi quality", "cleanliness", "outlets availability"]
    var categoryScore: [UILabel] = [UILabel(), UILabel(), UILabel()]
    var reviews = [] as [Review]
    var cafeListener: ListenerRegistration?
    var reviewListener: ListenerRegistration?
    
    lazy var chatButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = background1
        
        var title = AttributedString("Live Chat")
        title.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        config.attributedTitle = title
        button.configuration = config
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openCafeChat), for: .touchUpInside)
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        return label
    }()
    
    lazy var status: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = background2
        return label
    }()
    
    lazy var favButton: UIButton = {
        let button = UIButton(type: .custom)
        let heartImage = UIImage(systemName: "heart")
        button.setImage(heartImage, for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.alpha = 0.4
        label.alpha = 0.4
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
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
        cafeImage.contentMode = .scaleToFill
        cafeImage.contentMode = .scaleAspectFill
        cafeImage.translatesAutoresizingMaskIntoConstraints = false
        cafeImage.clipsToBounds = true
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
    
    let reviewsCellIdentifier = "ReviewsTableViewCellIdentifier"
    let reviewsTable = UITableView()
    let numReviews = UILabel()
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        //        setupUI()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTap()
        reviewsTable.dataSource = self
        reviewsTable.delegate = self
        reviewsTable.register(ReviewsTableViewCell.self, forCellReuseIdentifier: reviewsCellIdentifier)
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cafeListener?.remove()
        reviewListener?.remove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let name = place.name
        let coordinate = place.location.coordinate
        fetchPlaceIDFromGoogle(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude) { placeID in
            if let placeID = placeID {
                self.fetchPlaceDetails(placeID: placeID) { details in
                    if let details = details {
                        DispatchQueue.main.async {
                            self.reviewsTable.reloadData()
                            print("api details: \(details)")
                            if let address = details["formatted_address"] as? String {
                                self.addressLabel.text = address
                            }
                            if let testRating = details["rating"] as? Double {
                                self.rating = testRating
                                //                                self.overallRating.text = String(format: "%.1f", self.rating)
                            }
                            if let newName = details["name"] as? String {
                                self.nameLabel.text = newName
                            }
                            
                            //                            self.setupUI()
                            
                            if let photos = details["photos"] as? [[String: Any]],
                               let photoRef = photos.first?["photo_reference"] as? String {
                                
                                let maxWidth = 200
                                let photoURLStr = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(maxWidth)&photoreference=\(photoRef)&key=AIzaSyCboeBjmEs9hC45LBdQse8s67u2lByWsn0"
                                
                                if let photoURL = URL(string: photoURLStr) {
                                    URLSession.shared.dataTask(with: photoURL) { data, response, error in
                                        if let data = data, let image = UIImage(data: data) {
                                            DispatchQueue.main.async {
                                                self.cafeImage.image = image
                                                CafeManager().updateDocument(uid: self.place.placeId, data: ["image": photoURL.absoluteString])
                                            }
                                        }
                                    }.resume()
                                }
                            }
                            
                            
                        }
                    }
                }
            } else {
                print("no placeID found")
                DispatchQueue.main.async {
                    //                    self.setupUI() // fallback setup even if API fails
                }
            }
        }
    }
    
    func fetchPlaceIDFromGoogle(name: String, latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let apiKey = "AIzaSyCboeBjmEs9hC45LBdQse8s67u2lByWsn0"
        
        let query = "\(name)"
        let location = "\(latitude),\(longitude)"
        let radius = 100  // meters
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlStr = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedQuery)&location=\(location)&radius=\(radius)&key=\(apiKey)"
        print("api query: \(encodedQuery) @ \(location)")
        
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let first = results.first,
                   let placeID = first["place_id"] as? String {
                    completion(placeID)
                    print("Found placeID: \(placeID)")
                    
                } else {
                    print("placeID not found.")
                    if let data = data {
                        print(String(data: data, encoding: .utf8) ?? "Could not stringify data")
                    }
                    completion(nil)
                }
            }.resume()
        } else {
            completion(nil)
        }
    }
    
    func fetchPlaceDetails(placeID: String, completion: @escaping ([String: Any]?) -> Void) {
        let apiKey = "AIzaSyCboeBjmEs9hC45LBdQse8s67u2lByWsn0"
        let fields = "name,formatted_address,rating,opening_hours,photos"
        let urlStr = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeID)&fields=\(fields)&key=\(apiKey)"
        
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let result = json["result"] as? [String: Any] {
                    completion(result)
                } else {
                    completion(nil)
                }
            }.resume()
        } else {
            completion(nil)
        }
        Task {
            if let user = await UserManager().fetchUserDocument() {
                self.user = user
                print("User found: \(user)")
            } else {
                print("Failed to fetch user data")
            }
            
            if let cafe = await CafeManager().fetchCafeDocument(uid: place.placeId) {
                self.cafe = cafe
                self.listenToCafeStatus()
                self.listenToReviews()
                self.reviews = await ReviewManager().fetchAllReviews(forCafeId: cafe.uid)
                
                let count = Double(self.reviews.count)
                if count > 0 {
                    let wifiAvg = self.reviews.map { Double($0.wifi) }.reduce(0,+)/count
                    let cleanAvg = self.reviews.map { Double($0.cleanliness) }.reduce(0,+)/count
                    let outAvg = self.reviews.map { Double($0.outlets) }.reduce(0,+)/count
                    self.rating = (wifiAvg + cleanAvg + outAvg) / 3
                } else {
                    self.rating = 0
                }
                self.numReviews.text = "\(self.reviews.count) reviews"
                self.reviewsTable.reloadData()
                
                print("Cafe found: \(cafe)")
                print("CAFE STATUS: \(cafe.status)")
                status.text = cafe.status
                numReviews.text = "\(reviews.count) reviews"
                reviewsTable.reloadData()
                let favFlag = user?.favorites.contains(self.cafe?.uid ?? "") ?? false
                DispatchQueue.main.async {
                    //                    self.setupUI()
                    self.isFavorite = favFlag
                    if self.isFavorite {
                        self.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }
                }
            } else {
                print("Failed to fetch cafe data")
                print("Creating document")
                let newCafe = Cafe.empty(uid: place.placeId, name: place.name)
                CafeManager().createCafeDocument(cafe: newCafe)
                // set up ui after cafe is fetched and set (or created if not found)
                DispatchQueue.main.async {
                    self.cafe = newCafe
                    self.listenToCafeStatus()
                    self.listenToReviews()
                    //                    self.setupUI()
                }
            }
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder has not been implemented")
    }
    
    @objc func favButtonTapped(_ sender: UIButton) {
        isFavorite = !isFavorite
        let heartImg = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favButton.setImage(heartImg, for: .normal)
        
        //        add this cafe to the favorites
        if isFavorite {
            UserManager().addFavorite(uid: user!.uid, data: cafe!.uid)
            NotificationManager().listenForStatusChange(favorites: [cafe!.uid])
        }
        else {
            UserManager().deleteFavorite(uid: user!.uid, data: cafe!.uid)
        }
    }

    @objc func directionsButtonTapped(_ sender: UIButton) {
        let coordinate = place.location.coordinate
        guard let url = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") else {
            print("Error opening Apple Maps")
            return
        }
        UIApplication.shared.open(url)
    }
    
    private func updateRatingsFromReviews() {
        guard !reviews.isEmpty else {
            overallRating.text = "None"
            return
        }
        
        let totalWifi        = reviews.reduce(0) { $0 + $1.wifi }
        let totalCleanliness = reviews.reduce(0) { $0 + $1.cleanliness }
        let totalOutlets     = reviews.reduce(0) { $0 + $1.outlets }
        let count = Double(reviews.count)
        
        let avgWifi        = Double(totalWifi) / count
        let avgCleanliness = Double(totalCleanliness) / count
        let avgOutlets     = Double(totalOutlets) / count
        
        let overallAvg = (avgWifi + avgCleanliness + avgOutlets) / 3.0
        categoryScore[0].text = String(format: "%.1f/5", avgWifi)
        categoryScore[1].text = String(format: "%.1f/5", avgCleanliness)
        categoryScore[2].text = String(format: "%.1f/5", avgOutlets)
        overallRating.text = String(format: "%.1f", overallAvg)
    }
    
    
    @objc func reportStatusButtonTapped(_ sender: UIButton) {
        let controller = UIAlertController(
            title: "Report Current Status",
            message: place.name,
            preferredStyle: .actionSheet)
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel)
                             { (action) in print("Cancel")} )
        controller.addAction(UIAlertAction(title: "Extremely Busy", style: .default)
                             { (action) in self.submitStatus(status: "Extremely Busy")} )
        controller.addAction(UIAlertAction(title: "Very Busy", style: .default)
                             { (action) in self.submitStatus(status: "Very Busy")} )
        controller.addAction(UIAlertAction(title: "Moderately Busy", style: .default)
                             { (action) in self.submitStatus(status: "Moderately Busy")} )
        controller.addAction(UIAlertAction(title: "Not Busy", style: .default)
                             { (action) in self.submitStatus(status: "Not Busy")} )
        
        present(controller, animated: true)
    }
    
    
    
    @objc func addReviewButtonTapped(_ sender: UIButton) {
        let reviewVC = ShopReviewViewController(cafe: cafe!)
        
        reviewVC.onReviewSubmitted = { [weak self] in
            Task {
                guard let self = self else { return }
                guard let cafe = self.cafe else { return }
                self.reviews = await ReviewManager().fetchAllReviews(forCafeId: cafe.uid)
                DispatchQueue.main.async {
                    // remove subviews
                    self.view.subviews.forEach { $0.removeFromSuperview() }
                    // replace with updated UI
                    self.setupUI()
                    self.reviewsTable.reloadData()
                }
            }
        }
        reviewVC.modalPresentationStyle = .fullScreen
        present(reviewVC, animated: true)
    }
    
    func submitStatus(status: String) {
        print("\(status) reported")
        CafeManager().updateDocument(uid: place.placeId, data: ["status": status])
        self.cafe?.status = status
        self.status.text = status
        print("CAFE: \(String(describing: cafe))")
        //        self.currentStatus = status
    }

    
    func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .white
        separator.layer.cornerRadius = 1
        separator.layer.masksToBounds = true
        separator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(separator)
        return separator
    }
    
    private func setupUI() {
        view.backgroundColor = background3
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let contentBody = UIStackView()
        contentBody.translatesAutoresizingMaskIntoConstraints = false
        
        contentBody.axis = .vertical
        let topSection = UIView()
        topSection.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: -2.0  // reduce the letter spacing
        ]
        
        let lesserSpacing: [NSAttributedString.Key: Any] = [
            .kern: -1.0  // reduce the letter spacing
        ]

        let contactStackView = UIStackView()
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.axis = .horizontal
        contactStackView.spacing = 100
        contactStackView.alignment = .bottom
        
        // contactStackView.addArrangedSubview(addressLabel)
        contactStackView.addArrangedSubview(directionsButton)
        
        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        statusLabel.attributedText = NSAttributedString(string: "current status:", attributes: lesserSpacing)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        print("CAFE: \(String(describing: cafe))")
        print("STATUS: \(String(describing: cafe?.status))")
        status.attributedText = NSAttributedString(string: cafe?.status ?? "NO STATUS REPORTED", attributes: lesserSpacing)
        
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
        var i: Int = 0
        for category in categories {
            let labelView = UIView()
            labelView.translatesAutoresizingMaskIntoConstraints = false
            let label = UILabel()
            label.attributedText = NSAttributedString(string: category, attributes: lesserSpacing)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = background4
            label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
            
            let score = UILabel()
            score.attributedText = NSAttributedString(string: "N/A", attributes: lesserSpacing)
            score.translatesAutoresizingMaskIntoConstraints = false
            score.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            categoryScore[i] = score
            i += 1
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
        scrollView.addSubview(contentBody)
        contentBody.addArrangedSubview(topSection)
        topSection.addSubview(nameLabel)
        topSection.addSubview(favButton)
        topSection.addSubview(contactStackView)
        topSection.addSubview(cafeImage)
        topSection.addSubview(statusLabel)
        topSection.addSubview(status)
        topSection.addSubview(reportStatusButton)
        topSection.addSubview(ratingView)
        topSection.addSubview(detailedRatingView)
        topSection.addSubview(chatButton)
        
        NSLayoutConstraint.activate([
            chatButton.topAnchor.constraint(equalTo: reportStatusButton.bottomAnchor, constant: 10),
            chatButton.leadingAnchor.constraint(equalTo: topSection.leadingAnchor),
            chatButton.trailingAnchor.constraint(equalTo: topSection.trailingAnchor),
            //            chatButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        cafeImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        cafeImage.widthAnchor.constraint(equalTo: topSection.widthAnchor).isActive = true
        
        favButton.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
        // REVIEWS
        //        let reviewSection = UIView()
        //        reviewSection.translatesAutoresizingMaskIntoConstraints = false
        //        reviewSection.axis = .vertical
        //        contentBody.addArrangedSubview(reviewSection)
        
        let reviewBody = UIStackView()
        reviewBody.translatesAutoresizingMaskIntoConstraints = false
        reviewBody.axis = .vertical
        reviewBody.spacing = 10
        contentBody.addArrangedSubview(reviewBody)
        
        // Review title and add review button
        let reviewTitleAndButton = UIStackView()
        reviewTitleAndButton.translatesAutoresizingMaskIntoConstraints = false
        reviewTitleAndButton.axis = .horizontal
        reviewTitleAndButton.spacing = UIStackView.spacingUseSystem
        reviewTitleAndButton.alignment = .bottom
        reviewTitleAndButton.distribution = .equalSpacing
        
        let reviewTitle = UILabel()
        reviewTitle.attributedText = NSAttributedString(string: "Reviews", attributes: lesserSpacing)
        reviewTitle.translatesAutoresizingMaskIntoConstraints = false
        reviewTitle.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        let addReviewButton = UIButton()
        let underlined: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        addReviewButton.setAttributedTitle(NSAttributedString(string: "+ Add your own", attributes: underlined), for: .normal)
        addReviewButton.translatesAutoresizingMaskIntoConstraints = false
        addReviewButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        reviewTitleAndButton.addArrangedSubview(reviewTitle)
        reviewTitleAndButton.addArrangedSubview(addReviewButton)
        reviewBody.addArrangedSubview(reviewTitleAndButton)
        
        numReviews.attributedText = NSAttributedString(string: "\(reviews.count) reviews", attributes: lesserSpacing)
        numReviews.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        numReviews.textColor = grayText
        numReviews.translatesAutoresizingMaskIntoConstraints = false
        reviewBody.addArrangedSubview(numReviews)
        
        reviewsTable.translatesAutoresizingMaskIntoConstraints = false
        reviewsTable.backgroundColor = background3
        reviewsTable.estimatedRowHeight = 200
        reviewsTable.rowHeight = UITableView.automaticDimension
        contentBody.addArrangedSubview(reviewsTable)
        
        // EVENT HANDLERS
        directionsButton.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        reportStatusButton.addTarget(self, action: #selector(reportStatusButtonTapped), for: .touchUpInside)
        addReviewButton.addTarget(self, action: #selector(addReviewButtonTapped), for: .touchUpInside)
        
        // CONSTRAINTS
        NSLayoutConstraint.activate([
            contentBody.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 50),
            contentBody.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 40),
            contentBody.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -40),
            contentBody.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -80),
            contentBody.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            topSection.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            topSection.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
            topSection.topAnchor.constraint(equalTo: contentBody.topAnchor),
        ])
        
        // Cafe Name Contraints
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
            cafeImage.topAnchor.constraint(equalTo: contactStackView.bottomAnchor, constant: 10),
            cafeImage.heightAnchor.constraint(equalToConstant: 150)
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
            ratingView.topAnchor.constraint(equalTo: chatButton.bottomAnchor, constant: 15),
            
            overallRating.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 1),
            
            detailedRatingView.topAnchor.constraint(equalTo: ratingView.topAnchor),
            detailedRatingView.trailingAnchor.constraint(equalTo: topSection.trailingAnchor),
            detailedRatingView.widthAnchor.constraint(equalToConstant: 160),
            detailedRatingView.heightAnchor.constraint(equalToConstant: 180),
            
            detailedContentView.bottomAnchor.constraint(equalTo: detailedRatingView.bottomAnchor, constant: -15),
            detailedContentView.leadingAnchor.constraint(equalTo: detailedRatingView.leadingAnchor, constant: 15),
            detailedContentView.topAnchor.constraint(equalTo: detailedRatingView.topAnchor, constant: 15),
            detailedContentView.trailingAnchor.constraint(equalTo: detailedRatingView.trailingAnchor, constant: -15),
            
            topSection.bottomAnchor.constraint(equalTo: detailedRatingView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            reviewBody.leadingAnchor.constraint(equalTo: topSection.leadingAnchor),
            reviewBody.trailingAnchor.constraint(equalTo: topSection.trailingAnchor),
            reviewBody.topAnchor.constraint(equalTo: topSection.bottomAnchor)
        ])
        
        //        NSLayoutConstraint.activate([
        //            reviewBody.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor, constant: 40),
        //            reviewBody.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor, constant: -40),
        //            reviewBody.topAnchor.constraint(equalTo: reviewSection.topAnchor, constant: 35),
        //        ])
        
        NSLayoutConstraint.activate([
            //            reviewTitleAndButton.leadingAnchor.constraint(equalTo: reviewBody.leadingAnchor),
            //            reviewTitleAndButton.trailingAnchor.constraint(equalTo: reviewBody.trailingAnchor)
            reviewTitleAndButton.widthAnchor.constraint(equalTo: reviewBody.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            //            numReviews.topAnchor.constraint(equalTo: reviewTitleAndButton.bottomAnchor, constant: 20),
            numReviews.leadingAnchor.constraint(equalTo: reviewBody.leadingAnchor),
            numReviews.trailingAnchor.constraint(equalTo: reviewBody.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            //            reviewDisplay.topAnchor.constraint(equalTo: numReviews.bottomAnchor, constant: 5),
            //            reviewDisplay.leadingAnchor.constraint(equalTo: reviewBody.leadingAnchor),
            //            reviewDisplay.trailingAnchor.constraint(equalTo: reviewBody.trailingAnchor),
            
            reviewsTable.leadingAnchor.constraint(equalTo: reviewBody.leadingAnchor),
            reviewsTable.trailingAnchor.constraint(equalTo: reviewBody.trailingAnchor),
            reviewsTable.topAnchor.constraint(equalTo: numReviews.bottomAnchor, constant: 20),
            reviewsTable.heightAnchor.constraint(greaterThanOrEqualToConstant: 500)
        ])
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(reviews.count)
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTable.dequeueReusableCell(withIdentifier: reviewsCellIdentifier, for: indexPath) as! ReviewsTableViewCell
        let review = reviews[indexPath.row]
        cell.review = Review(uid: review.uid, displayName: review.displayName, date: review.date, text: review.text, wifi: review.wifi, cleanliness: review.cleanliness, outlets: review.outlets, photos: review.photos)
        return cell
    }
    
    func listenToCafeStatus() {
        guard let cafeId = cafe?.uid else { return }
        cafeListener = Firestore.firestore()
            .collection("cafes")
            .document(cafeId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let data = snapshot?.data(),
                      let newStatus = data["status"] as? String else {
                    return
                }
                DispatchQueue.main.async {
                    self?.status.text = newStatus
                }
            }
    }
    
    func listenToReviews() {
        guard let cafeId = cafe?.uid else { return }
        reviewListener = Firestore.firestore()
            .collection("cafes")
            .document(cafeId)
            .collection("reviews")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let documents = snapshot?.documents else { return }
                self.reviews = documents.compactMap { doc in
                    try? doc.data(as: Review.self)
                }
                DispatchQueue.main.async {
                    self.reviewsTable.reloadData()
                    self.numReviews.text = "\(self.reviews.count) reviews"
                    self.updateRatingsFromReviews()
                }
            }
    }
}

extension PlaceDetailViewController {
    @objc func openCafeChat() {
        guard let cafe = self.cafe else { return }
        let uid = Auth.auth().currentUser?.uid ?? ""
        Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                let displayName = snapshot?.data()?["displayName"] as? String ?? "Guest"
                let chatVC = CafeChatViewController()
                chatVC.cafeId      = cafe.uid
                chatVC.displayName = displayName
                let nav = UINavigationController(rootViewController: chatVC)
                self.present(nav, animated: true)
            }
    }
}


