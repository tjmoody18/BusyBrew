//
//  AddFriendsViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 4/21/25.
//

import UIKit
import Firebase
import FirebaseAuth

class AddFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    struct Friend {
        let uid: String
        let name: String
        let email: String
    }
    let db = Firestore.firestore()
    let currentUserEmail = Auth.auth().currentUser?.email ?? ""
    let currentUserUID = Auth.auth().currentUser?.uid ?? ""
    let tightSpacing: [NSAttributedString.Key: Any] = [.kern: -2.0]
    let addFriendField = UITextField()
    let friendsTable = UITableView()
    let friendsCellIdentifier = "FriendsTableViewCellIdentifier"
    var friendsList: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTable.dataSource = self
        friendsTable.delegate = self
        friendsTable.register(FriendsTableViewCell.self, forCellReuseIdentifier: friendsCellIdentifier)
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = background3

        let backButton = createBackButton()

        let contentBody = UIStackView()
        contentBody.translatesAutoresizingMaskIntoConstraints = false
        contentBody.axis = .vertical
        contentBody.alignment = .leading
        contentBody.spacing = 5

        view.addSubview(contentBody)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.attributedText = NSAttributedString(string: "Add Friends", attributes: tightSpacing)
        title.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        title.textColor = background1

        let addStack = UIStackView()
        addStack.axis = .horizontal
        addStack.translatesAutoresizingMaskIntoConstraints = false
        addStack.spacing = 5
        addStack.alignment = .center
        addStack.distribution = .fillProportionally
        
        addFriendField.translatesAutoresizingMaskIntoConstraints = false
        addFriendField.placeholder = "Enter email"
        addFriendField.borderStyle = .roundedRect
        addFriendField.font = .systemFont(ofSize: 14, weight: .regular)
        
        let addButton = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        config.baseBackgroundColor = background1
        var buttonTitle = AttributedString("Add")
        buttonTitle.font = .systemFont(ofSize: 14, weight: .semibold)
        config.attributedTitle = buttonTitle
        addButton.configuration = config
        addButton.addTarget(self, action: #selector(addFriendTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        friendsTable.translatesAutoresizingMaskIntoConstraints = false
        friendsTable.backgroundColor = background3
        friendsTable.estimatedRowHeight = 100
        friendsTable.rowHeight = UITableView.automaticDimension
        
        addStack.addArrangedSubview(addFriendField)
        addStack.addArrangedSubview(addButton)
        
        contentBody.addArrangedSubview(backButton)
        contentBody.addArrangedSubview(title)
        contentBody.addArrangedSubview(addStack)
        contentBody.addArrangedSubview(friendsTable)

        NSLayoutConstraint.activate([
            contentBody.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentBody.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentBody.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            contentBody.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            contentBody.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
            addStack.widthAnchor.constraint(equalTo: contentBody.widthAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalTo: addFriendField.heightAnchor),
            friendsTable.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            friendsTable.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            friendsTable.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
        ])
    }
    
    @objc func addFriendTapped() {
        let email = addFriendField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if email.isEmpty || currentUserUID.isEmpty {
            showAlert(title: "Error", message: "Please enter a valid email.")
            return
        }

        if email == currentUserEmail {
            showAlert(title: "Invalid", message: "You cannot add yourself.")
            return
        }

        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let doc = snapshot?.documents.first {
                let friendUID = doc.documentID
                let friendName = doc.data()["displayName"] as? String ?? "Unknown"
                let friendEmail = doc.data()["email"] as? String ?? ""

                // Check if already friends
                self.db.collection("users").document(friendUID).getDocument { friendDoc, _ in
                    let theirFriends = friendDoc?.data()?["friends"] as? [String] ?? []
                    if theirFriends.contains(self.currentUserUID) {
                        self.showAlert(title: "Already Friends", message: "You're already friends with this user.")
                        return
                    }

                    // Check if request already sent
                    self.db.collection("users").document(friendUID).collection("friendRequests")
                        .document(self.currentUserUID).getDocument { reqDoc, _ in
                            if reqDoc?.exists == true {
                                self.showAlert(title: "Already Requested", message: "Friend request already sent.")
                                return
                            }

                            // Send request
                            self.db.collection("users").document(friendUID)
                                .collection("friendRequests")
                                .document(self.currentUserUID)
                                .setData([
                                    "timestamp": FieldValue.serverTimestamp(),
                                    "email": self.currentUserEmail
                                ]) { err in
                                    if let err = err {
                                        self.showAlert(title: "Error", message: err.localizedDescription)
                                    } else {
                                        DispatchQueue.main.async {
                                            self.addFriendField.text = ""
                                            self.showAlert(title: "Sent", message: "Friend request sent to \(friendName)!")
                                        }
                                    }
                                }
                        }
                }
            } else {
                self.showAlert(title: "Error", message: "User not found.")
            }
        }
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

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTable.dequeueReusableCell(withIdentifier: friendsCellIdentifier, for: indexPath as IndexPath) as? FriendsTableViewCell
        let friend = friendsList[indexPath.row]
        cell?.profilePicture.image = UIImage(named: "cafe.png")
        cell?.nameLabel.text = friend.name
        return cell!
    }

}
