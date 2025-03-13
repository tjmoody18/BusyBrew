//
//  FavoritesViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 3/11/25.
//

import UIKit

class FavoritesViewController: UIViewController {

    let backButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = background3
        createBackButton()
        addHeaders()
    }
    
    func addHeaders() {
        // Create and add "Favorites" Label
        let favoritesLabel = UILabel()
        favoritesLabel.text = "Favorites"
        favoritesLabel.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        favoritesLabel.textColor = UIColor(red: 88/255, green: 136/255, blue: 59/255, alpha: 1) // Custom green
        favoritesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favoritesLabel)
        
        // Create and add Subheader Label
        let subtitleLabel = UILabel()
        subtitleLabel.text = "All your favs in one spot."
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = UIColor.black.withAlphaComponent(0.7)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            // Back Button Constraints
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            // Header Constraints
            favoritesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            favoritesLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 5),
            
            // Subheader constraints
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
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
        backButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
}
