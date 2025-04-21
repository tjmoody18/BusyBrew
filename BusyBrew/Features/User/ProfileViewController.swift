//
//  ProfileViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 4/21/25.
//

import UIKit

class ProfileViewController: UIViewController {
    // User ID to fetch data
    var userId: String?
    let tightSpacing: [NSAttributedString.Key: Any] = [.kern: -2.0]
    var name: String?
    
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
        contentBody.spacing = 5
        
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
        profilePic.layer.cornerRadius = 40
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.attributedText = NSAttributedString(string: name ?? "User", attributes: tightSpacing)
        nameLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        nameLabel.textColor = background1
        
        headerStack.addArrangedSubview(profilePic)
        headerStack.addArrangedSubview(nameLabel)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentBody)
        contentBody.addArrangedSubview(backButton)
        contentBody.addArrangedSubview(headerStack)
        
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
