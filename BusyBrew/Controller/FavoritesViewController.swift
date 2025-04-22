

//
//  FavoritesViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 3/11/25.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var favorites: [Cafe] = []
    
    let backButton = UIButton(type: .system)
    let favoritesTable = UITableView()
    let favoritesLabel = UILabel()
    let subtitleLabel = UILabel()
    let favoriteCellIdentifier = "FavoriteTableViewCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTable.register(FavoriteTableViewCell.self, forCellReuseIdentifier: favoriteCellIdentifier)
        setupUI()
        favoritesTable.dataSource = self
        favoritesTable.delegate = self
        getFavorites()
        print("check for favorites", self.favorites)
    }
    
    func setupUI() {
        view.backgroundColor = background3
        createBackButton()
        addHeaders()
        favoritesTable.reloadData()
        setupTable()
    }
    
    func setupTable() {
        favoritesTable.dataSource = self
        favoritesTable.delegate = self
        favoritesTable.translatesAutoresizingMaskIntoConstraints = false
        favoritesTable.backgroundColor = background3
        favoritesTable.estimatedRowHeight = 100
        favoritesTable.rowHeight = UITableView.automaticDimension
        view.addSubview(favoritesTable)
        
        NSLayoutConstraint.activate([
            favoritesTable.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 25),
            favoritesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoritesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoritesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addHeaders() {
        // Create and add "Favorites" Label
        favoritesLabel.text = "Favorites"
        favoritesLabel.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        favoritesLabel.textColor = UIColor(red: 88/255, green: 136/255, blue: 59/255, alpha: 1) // Custom green
        favoritesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favoritesLabel)
        
        // Create and add Subheader Label
        subtitleLabel.text = "All your favs in one spot."
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = UIColor.black.withAlphaComponent(0.7)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            favoritesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            favoritesLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 5),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            subtitleLabel.topAnchor.constraint(equalTo: favoritesLabel.bottomAnchor, constant: 5)
        ])
    }
    
    func createBackButton() {
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        backButton.titleLabel?.attributedText = NSAttributedString(string: backButton.titleLabel?.text ?? "", attributes: attributes)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTable.dequeueReusableCell(withIdentifier: favoriteCellIdentifier, for: indexPath as IndexPath) as? FavoriteTableViewCell
        let cafeFavorite = favorites[indexPath.row]
        cell?.cafeImage.image = UIImage(named: cafeFavorite.image)
        cell?.nameLabel.text = cafeFavorite.name
        cell?.statusLabel.text = cafeFavorite.status
        return cell!
    }
    
    func getFavorites() {
        Task {
            if let user = await UserManager().fetchUserDocument() {
                for fav in user.favorites {
                    print("Here user found")
                    let cafe = await CafeManager().fetchCafeDocument(uid: fav)
                    self.favorites.append(cafe!)
                }
                DispatchQueue.main.async {
                    self.favoritesTable.reloadData()
                }
                print("User found: \(user)")
            } else {
                print("Failed to fetch user data")
            }
        }
        favoritesTable.reloadData()
    }
}
