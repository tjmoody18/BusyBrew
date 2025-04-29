//  ProfileViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 4/21/25.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {
    var userId: String?
    let tightSpacing: [NSAttributedString.Key: Any] = [.kern: -2.0]
    var name: String?
    let currentUserUID = Auth.auth().currentUser?.uid ?? ""
    
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let numFriendsLabel = UILabel()
    private let numFavsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTap()
        setupUI()
        fetchProfileData()
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
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.attributedText = NSAttributedString(string: name ?? "Donald Thai", attributes: tightSpacing)
        nameLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        nameLabel.textColor = background1
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.text = "@donaldthai"
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        usernameLabel.textColor = grayText
        
        nameStack.addArrangedSubview(nameLabel)
        nameStack.addArrangedSubview(usernameLabel)
        headerStack.addArrangedSubview(profilePic)
        headerStack.addArrangedSubview(nameStack)
        
        // stats rows
        let rows = UIStackView()
        rows.translatesAutoresizingMaskIntoConstraints = false
        rows.axis = .vertical
        rows.alignment = .fill
        rows.spacing = 10
        
        let friends = UIView()
        friends.backgroundColor = darkBlue
        let favorites = UIView()
        favorites.backgroundColor = background1Light
        
        [friends, favorites].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }
        
        let friendsData = UIStackView()
        friendsData.translatesAutoresizingMaskIntoConstraints = false
        friendsData.axis = .vertical
        friendsData.alignment = .leading
        friendsData.spacing = -4
        
        numFriendsLabel.text = "0"
        numFriendsLabel.font = UIFont.systemFont(ofSize: 60, weight: .black)
        numFriendsLabel.textColor = .white
        let friendsLabel = UILabel()
        friendsLabel.text = "Friends"
        friendsLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        friendsLabel.textColor = .white
        
        friendsData.addArrangedSubview(numFriendsLabel)
        friendsData.addArrangedSubview(friendsLabel)
        friends.addSubview(friendsData)
        
        let favoritesData = UIStackView()
        favoritesData.translatesAutoresizingMaskIntoConstraints = false
        favoritesData.axis = .vertical
        favoritesData.alignment = .leading
        favoritesData.spacing = -2
        
        numFavsLabel.text = "0"
        numFavsLabel.font = UIFont.systemFont(ofSize: 60, weight: .black)
        numFavsLabel.textColor = .white
        let favsLabel = UILabel()
        favsLabel.text = "Favorites"
        favsLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        favsLabel.textColor = .white
        
        favoritesData.addArrangedSubview(numFavsLabel)
        favoritesData.addArrangedSubview(favsLabel)
        favorites.addSubview(favoritesData)
        
        let row1 = UIStackView(arrangedSubviews: [friends])
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
        ])
        
        if userId == currentUserUID {
            friends.isUserInteractionEnabled = true
            friends.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(openFriendsList)
                )
            )
        } else {
            friends.isUserInteractionEnabled = false
            friends.alpha = 0.5
        }
        
        favorites.isUserInteractionEnabled = true
        favorites.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openFavoritesList)))
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func createBackButton() -> UIButton {
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return backButton
    }
    
    @objc private func openFriendsList() {
        let vc = FriendsViewController()
        vc.userId = userId ?? currentUserUID
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func openFavoritesList() {
        let vc = FavoritesViewController()
        vc.userId = userId ?? currentUserUID
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func fetchProfileData() {
        let uid = userId ?? currentUserUID
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            let displayName = data["displayName"] as? String ?? ""
            let friends = (data["friends"] as? [String])?.count ?? 0
            let favs = (data["favorites"] as? [String])?.count ?? 0
            
            DispatchQueue.main.async {
                self.nameLabel.attributedText = NSAttributedString(string: displayName, attributes: self.tightSpacing)
                self.usernameLabel.text = "@\(displayName.lowercased())"
                self.numFriendsLabel.text = "\(friends)"
                self.numFavsLabel.text = "\(favs)"
            }
        }
    }
}
