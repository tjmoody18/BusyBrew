//
//  ProfileViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 4/21/25.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {
    // User ID to fetch data
    var userId: String?
    let tightSpacing: [NSAttributedString.Key: Any] = [.kern: -2.0]
    var name: String?
    let currentUserUID = Auth.auth().currentUser?.uid ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = background3
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let contentBody = UIStackView()
        contentBody.translatesAutoresizingMaskIntoConstraints = false
        contentBody.axis = .vertical
        contentBody.alignment = .leading
        contentBody.spacing = 10
        
        let backButton = createBackButton()
        
        let headerStack = UIStackView()
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.axis = .vertical
        headerStack.alignment = .leading
        headerStack.spacing = 5
        
        let profilePic = UIImageView()
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.contentMode = .scaleAspectFill
        profilePic.clipsToBounds = true
        profilePic.image = UIImage(named: "cafe.png")
        profilePic.layer.cornerRadius = 50
        
        let nameStack = UIStackView()
        nameStack.translatesAutoresizingMaskIntoConstraints = false
        nameStack.axis = .vertical
        nameStack.alignment = .leading
        nameStack.spacing = -1
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.attributedText = NSAttributedString(string: name ?? "Donald Thai", attributes: tightSpacing)
        nameLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        nameLabel.textColor = background1
        
        let usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.text = "@donaldthai"
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        usernameLabel.textColor = grayText
        
        nameStack.addArrangedSubview(nameLabel)
        nameStack.addArrangedSubview(usernameLabel)
        headerStack.addArrangedSubview(profilePic)
        headerStack.addArrangedSubview(nameStack)
        let friendsButton: UIButton?
        if true {
            // TODO: ADD LOGIC TO CHECK IF FRIEND IS ADDED OR NOT
            if true {
                friendsButton = UIButton()
                var config = UIButton.Configuration.filled()
                var title = AttributedString("+ Add friends")
                title.font = .systemFont(ofSize: 12, weight: .bold)
                config.attributedTitle = title
                config.baseBackgroundColor = background1Light
                config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
                config.cornerStyle = .small
                friendsButton!.configuration = config
                
                headerStack.addArrangedSubview(friendsButton!)
            } else {
                friendsButton = UIButton()
                var config = UIButton.Configuration.filled()
                var title = AttributedString("- Remove Friend")
                title.font = .systemFont(ofSize: 12, weight: .bold)
                config.attributedTitle = title
                config.baseBackgroundColor = background1Light
                config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
                config.cornerStyle = .small
                friendsButton!.configuration = config
                headerStack.addArrangedSubview(friendsButton!)
            }
        }
        
        let rows = UIStackView()
        rows.translatesAutoresizingMaskIntoConstraints = false
        rows.axis = .vertical
        rows.alignment = .fill
        rows.spacing = 10
        
        let favorites = UIView()
        let friends = UIView()
        let reviews = UIView()
        
        [favorites, friends, reviews].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            // Add a fixed height so they appear as “rectangles”
            $0.heightAnchor.constraint(equalToConstant: 150).isActive = true
            $0.backgroundColor = background1Light
        }
        
        let friendsData = UIStackView()
        friendsData.translatesAutoresizingMaskIntoConstraints = false
        friendsData.axis = .vertical
        friendsData.alignment = .leading
        friendsData.spacing = -4
        
        let numFriends = UILabel()
        numFriends.text = "50"
        numFriends.font = UIFont.systemFont(ofSize: 60, weight: .black)
        
        let friendsLabel = UILabel()
        friendsLabel.text = "Friends"
        friendsLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        friendsData.addArrangedSubview(numFriends)
        friendsData.addArrangedSubview(friendsLabel)
        friends.addSubview(friendsData)
        
        let favoritesData = UIStackView()
        favoritesData.translatesAutoresizingMaskIntoConstraints = false
        favoritesData.axis = .vertical
        favoritesData.alignment = .leading
        favoritesData.spacing = -2
        
        let numFavs = UILabel()
        numFavs.text = "50"
        numFavs.font = UIFont.systemFont(ofSize: 60, weight: .black)
        
        let favsLabel = UILabel()
        favsLabel.text = "Favorites"
        favsLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        favoritesData.addArrangedSubview(numFavs)
        favoritesData.addArrangedSubview(favsLabel)
        favorites.addSubview(favoritesData)
        
        let reviewsData = UIStackView()
        reviewsData.translatesAutoresizingMaskIntoConstraints = false
        reviewsData.axis = .vertical
        reviewsData.alignment = .leading
        reviewsData.spacing = -2
        
        let numReviews = UILabel()
        numReviews.text = "50"
        numReviews.font = UIFont.systemFont(ofSize: 60, weight: .black)
        
        let reviewsLabel = UILabel()
        reviewsLabel.text = "Reviews"
        reviewsLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        reviewsData.addArrangedSubview(numReviews)
        reviewsData.addArrangedSubview(reviewsLabel)
        reviews.addSubview(reviewsData)
        
        
        let row1 = UIStackView(arrangedSubviews: [friends, reviews])
        row1.axis = .horizontal
        row1.distribution = .fillEqually
        row1.spacing = 10
        row1.translatesAutoresizingMaskIntoConstraints = false
        
        rows.addArrangedSubview(row1)
        rows.addArrangedSubview(favorites)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentBody)
        contentBody.addArrangedSubview(backButton)
        contentBody.addArrangedSubview(headerStack)
        contentBody.addArrangedSubview(rows)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            contentBody.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            contentBody.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentBody.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            contentBody.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            contentBody.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -80),
            
            backButton.topAnchor.constraint(equalTo: contentBody.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            
            headerStack.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
            
            profilePic.topAnchor.constraint(equalTo: headerStack.topAnchor, constant: 20),
            profilePic.heightAnchor.constraint(equalToConstant: 100),
            profilePic.widthAnchor.constraint(equalToConstant: 100),
            
            rows.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            rows.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
            
            friendsData.leadingAnchor.constraint(equalTo: friends.leadingAnchor, constant: 15),
            friendsData.trailingAnchor.constraint(equalTo: friends.trailingAnchor, constant: -15),
            friendsData.centerYAnchor.constraint(equalTo: friends.centerYAnchor),
            
            favoritesData.leadingAnchor.constraint(equalTo: favorites.leadingAnchor, constant: 15),
            favoritesData.trailingAnchor.constraint(equalTo: favorites.trailingAnchor, constant: -15),
            favoritesData.centerYAnchor.constraint(equalTo: favorites.centerYAnchor),
            
            reviewsData.leadingAnchor.constraint(equalTo: reviews.leadingAnchor, constant: 15),
            reviewsData.trailingAnchor.constraint(equalTo: reviews.trailingAnchor, constant: -15),
            reviewsData.centerYAnchor.constraint(equalTo: reviews.centerYAnchor),
        ])
    }
    
    func createBackButton() -> UIButton {
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return backButton
    }

    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
}
