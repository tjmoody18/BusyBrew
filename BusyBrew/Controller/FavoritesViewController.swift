//
//  FavoritesViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 3/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var favorites: [Cafe] = []
    var userId: String?
    
    let busyColorCode: [String: UIColor] = [
        "Not Busy": .green,
        "Moderately Busy": .yellow,
        "Very Busy": .orange,
        "Extremely Busy": .red
    ]
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
    }
    
    func setupUI() {
        view.backgroundColor = background3
        createBackButton()
        addHeaders()
        setupTable()
    }
    
    func setupTable() {
        favoritesTable.translatesAutoresizingMaskIntoConstraints = false
        favoritesTable.backgroundColor = background3
        favoritesTable.estimatedRowHeight = 100
        favoritesTable.rowHeight = UITableView.automaticDimension
        view.addSubview(favoritesTable)
        
        NSLayoutConstraint.activate([
            favoritesTable.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 5),
            favoritesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoritesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoritesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addHeaders() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        favoritesLabel.text = "Favorites"
        favoritesLabel.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        favoritesLabel.textColor = UIColor(red: 88/255, green: 136/255, blue: 59/255, alpha: 1)
        favoritesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favoritesLabel)
        
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
        backButton.titleLabel?.attributedText = NSAttributedString(
            string: backButton.titleLabel?.text ?? "",
            attributes: attributes
        )
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTable.dequeueReusableCell(
            withIdentifier: favoriteCellIdentifier,
            for: indexPath
        ) as! FavoriteTableViewCell
        let cafeFavorite = favorites[indexPath.row]
        if let photoURL = URL(string: cafeFavorite.image) {
            URLSession.shared.dataTask(with: photoURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let updateCell = tableView.cellForRow(at: indexPath) as? FavoriteTableViewCell {
                              updateCell.cafeImage.image = image
                            updateCell.statusLabel.textColor = self.busyColorCode[cafeFavorite.status]
                            }
                    }
                }
            }.resume()
        }
        cell.nameLabel.text = cafeFavorite.name
        cell.statusLabel.text = cafeFavorite.status
        return cell
    }
    
    private func getFavorites() {
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        let db = Firestore.firestore()
        
        db.collection("users")
          .document(uid)
          .getDocument { [weak self] snapshot, error in
            guard let self = self,
                  let data = snapshot?.data(),
                  let favIDs = data["favorites"] as? [String] else {
                return
            }
            
            Task {
                var loaded: [Cafe] = []
                for favID in favIDs {
                    if let cafe = await CafeManager().fetchCafeDocument(uid: favID) {
                        loaded.append(cafe)
                    }
                }
                DispatchQueue.main.async {
                    self.favorites = loaded
                    self.favoritesTable.reloadData()
                }
            }
        }
    }
}
