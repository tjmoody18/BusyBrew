//
//  FriendsViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 4/9/25.
//

import UIKit

class FriendsViewController: UIViewController {
    struct Friend {
        let uid: String
        let name: String
    }

    // Dummy list of friends
    let dummyFriends: [Friend] = [
        Friend(uid: "uid001", name: "Alice Johnson"),
        Friend(uid: "uid002", name: "Bob Smith"),
        Friend(uid: "uid003", name: "Charlie Brown"),
        Friend(uid: "uid004", name: "Diana Prince"),
        Friend(uid: "uid005", name: "Ethan Hunt"),
        Friend(uid: "uid001", name: "Alice Johnson"),
        Friend(uid: "uid002", name: "Bob Smith"),
        Friend(uid: "uid003", name: "Charlie Brown"),
        Friend(uid: "uid004", name: "Diana Prince"),
        Friend(uid: "uid005", name: "Ethan Hunt")
    ]
    
    let backButton = UIButton(type: .system)
    let tightSpacing: [NSAttributedString.Key: Any] = [
        .kern: -2.0  // reduce the letter spacing
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        view.backgroundColor = background3
        createBackButton()
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        
        let contentBody = UIStackView()
        contentBody.translatesAutoresizingMaskIntoConstraints = false
        contentBody.axis = .vertical
        contentBody.spacing = 10
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.attributedText = NSAttributedString(string: "Friends", attributes: tightSpacing)
        title.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        title.textColor = background1
        
        let friendsStack = UIStackView()
        friendsStack.axis = .vertical
        friendsStack.translatesAutoresizingMaskIntoConstraints = false
        friendsStack.spacing = 20
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentBody)
        contentBody.addArrangedSubview(title)
        contentBody.addArrangedSubview(friendsStack)
//        contentBody.backgroundColor = .red
//        friendsStack.backgroundColor = .blue
//        scrollView.backgroundColor = .yellow
        
        var lastFriend: UIStackView? = nil
        var count = 0
        for friend in dummyFriends {
            let friendItem = createFriendItem(friend: friend)
            friendsStack.addArrangedSubview(friendItem)
            NSLayoutConstraint.activate([
                friendItem.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
                friendItem.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
                friendItem.widthAnchor.constraint(equalTo: contentBody.widthAnchor)
            ])
            
            if let lastFriend = lastFriend {
                friendItem.topAnchor.constraint(equalTo: lastFriend.bottomAnchor, constant: 20).isActive = true
            } else {
                friendItem.topAnchor.constraint(equalTo: friendsStack.topAnchor, constant: 10).isActive = true
            }
            
            lastFriend = friendItem
            
            if count != dummyFriends.count - 1 {
                let separator = createSeparator()
                NSLayoutConstraint.activate([
                    separator.leadingAnchor.constraint(equalTo: friendItem.leadingAnchor),
                    separator.trailingAnchor.constraint(equalTo: friendItem.trailingAnchor),
                    separator.topAnchor.constraint(equalTo: friendItem.bottomAnchor, constant: 10),
                    separator.heightAnchor.constraint(equalToConstant: 2)
                ])
            }
            count += 1
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentBody.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentBody.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentBody.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            contentBody.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            contentBody.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            title.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
//            title.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
//            title.topAnchor.constraint(equalTo: contentBody.topAnchor)
//        ])
//        
//        NSLayoutConstraint.activate([
//            friendsStack.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
//            friendsStack.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
//        ])
        
        view.layoutIfNeeded()
        print()
        print("ScrollView content size: \(scrollView.contentSize)")
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
    
    func createFriendItem(friend: Friend) -> UIStackView {
        let friendItem = UIStackView()
        friendItem.axis = .horizontal
        friendItem.spacing = 10
        friendItem.translatesAutoresizingMaskIntoConstraints = false
        friendItem.alignment = .center
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "cafe.png")
        profileImageView.contentMode = .scaleToFill
        profileImageView.clipsToBounds = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.layer.cornerRadius = 60 / 2
        
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "\(friend.name)"
        name.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        friendItem.addArrangedSubview(profileImageView)
        friendItem.addArrangedSubview(name)
        return friendItem
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
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
}
