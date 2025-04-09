//
//  MenuViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 3/11/25.
//

import UIKit

class MenuViewController: UIViewController {
    
    let settingsSegueIdentifier = "SettingsSegue"
    let favoritesSegueIdentifier = "FavoritesSegue"
    let friendsSegueIdentifier = "FriendsSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        view.backgroundColor = background1Light
        let homeMenuButton = createMenuItem(title: "Home")
        let favoritesMenuButton = createMenuItem(title: "Favorites")
        let friendsMenuButton = createMenuItem(title: "Friends")
        let settingsMenuButton = createMenuItem(title: "Settings")
        
        homeMenuButton.addTarget(self, action: #selector(homeButtonClicked), for: .touchUpInside)
        favoritesMenuButton.addTarget(self, action: #selector(favsButtonClicked), for: .touchUpInside)
        settingsMenuButton.addTarget(self, action: #selector(settingsButtonClicked), for: .touchUpInside)
        friendsMenuButton.addTarget(self, action: #selector(friendsButtonClicked), for: .touchUpInside)
        
        let buttons: [UIButton] = [homeMenuButton, favoritesMenuButton, friendsMenuButton, settingsMenuButton]
        
        var lastButton: UIButton? = nil
        var count = 0
        for button in buttons {
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
                button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            ])
            
            if let lastButton = lastButton {
                button.topAnchor.constraint(equalTo: lastButton.bottomAnchor, constant: 30).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
            }
            
            lastButton = button
            
            if count != buttons.count - 1 {
                let separator = createSeparator()
                NSLayoutConstraint.activate([
                    separator.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                    separator.trailingAnchor.constraint(equalTo: button.trailingAnchor),
                    separator.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 15),
                    separator.heightAnchor.constraint(equalToConstant: 2)
                ])
            }
            count += 1
        }
    }
    
    func createMenuItem(title: String) -> UIButton {
        let menuItem = UIButton(type: .system)
        menuItem.setTitle(title, for: .normal)
        menuItem.setTitleColor(.white, for: .normal)
        menuItem.contentHorizontalAlignment = .left
        menuItem.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        menuItem.translatesAutoresizingMaskIntoConstraints = false
        return menuItem
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
    
    @objc func homeButtonClicked() {
        self.dismiss(animated: true)
    }
    
    @objc func favsButtonClicked() {
        performSegue(withIdentifier: favoritesSegueIdentifier, sender: self)
    }
    
    @objc func settingsButtonClicked() {
        performSegue(withIdentifier: settingsSegueIdentifier, sender: self)
    }
    
    @objc func friendsButtonClicked() {
        performSegue(withIdentifier: friendsSegueIdentifier, sender: self)
    }
}
