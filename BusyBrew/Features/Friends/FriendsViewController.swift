//  FriendsViewController.swift
//  BusyBrew
import UIKit
import Firebase
import FirebaseAuth

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    struct Friend {
        let uid: String
        let name: String
        let email: String
    }

    var friendsList: [Friend] = []
    var friendsStack = UIStackView()
    let db = Firestore.firestore()
    let currentUserEmail = Auth.auth().currentUser?.email ?? ""
    let currentUserUID = Auth.auth().currentUser?.uid ?? ""
    let tightSpacing: [NSAttributedString.Key: Any] = [.kern: -2.0]
    let emailField = UITextField()
    let friendsTable = UITableView()
    let friendsCellIdentifier = "FriendsTableViewCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTable.dataSource = self
        friendsTable.delegate = self
        friendsTable.register(FriendsTableViewCell.self, forCellReuseIdentifier: friendsCellIdentifier)
        setupUI()
        fetchFriends()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFriends()
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
        title.attributedText = NSAttributedString(string: "Friends", attributes: tightSpacing)
        title.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        title.textColor = background1

        // Add Friends button
        let addButton = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        config.baseBackgroundColor = background1
        var buttonTitle = AttributedString("+ Add Friends")
        buttonTitle.font = .systemFont(ofSize: 14, weight: .semibold)
        config.attributedTitle = buttonTitle
        addButton.configuration = config
        addButton.addTarget(self, action: #selector(addFriendTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false

        // Incoming Requests button
        let requestsButton = UIButton(type: .system)
        var requestConfig = UIButton.Configuration.filled()
        requestConfig.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        requestConfig.baseBackgroundColor = background1
        var requestTitle = AttributedString("Incoming Requests")
        requestTitle.font = .systemFont(ofSize: 14, weight: .semibold)
        requestConfig.attributedTitle = requestTitle
        requestsButton.configuration = requestConfig
        requestsButton.addTarget(self, action: #selector(openFriendRequests), for: .touchUpInside)
        requestsButton.translatesAutoresizingMaskIntoConstraints = false

        // Combine buttons into a horizontal row
        let buttonRow = UIStackView(arrangedSubviews: [addButton, requestsButton])
        buttonRow.axis = .horizontal
        buttonRow.spacing = 10
        buttonRow.alignment = .center
        buttonRow.distribution = .fillEqually
        buttonRow.translatesAutoresizingMaskIntoConstraints = false

        friendsTable.translatesAutoresizingMaskIntoConstraints = false
        friendsTable.backgroundColor = background3
        friendsTable.estimatedRowHeight = 100
        friendsTable.rowHeight = UITableView.automaticDimension

        contentBody.addArrangedSubview(backButton)
        contentBody.addArrangedSubview(title)
        contentBody.addArrangedSubview(buttonRow)
        contentBody.addArrangedSubview(friendsTable)

        NSLayoutConstraint.activate([
            contentBody.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentBody.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentBody.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            contentBody.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            contentBody.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),

            addButton.heightAnchor.constraint(equalToConstant: 40),
            requestsButton.heightAnchor.constraint(equalTo: addButton.heightAnchor),

            friendsTable.topAnchor.constraint(equalTo: buttonRow.bottomAnchor, constant: 10),
            friendsTable.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            friendsTable.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
        ])
    }

    
    @objc func openFriendRequests() {
        let requestVC = FriendRequestsViewController()
        requestVC.modalPresentationStyle = .fullScreen
        present(requestVC, animated: true)
    }


    @objc func addFriendTapped() {
        let addVC = AddFriendsViewController()
        addVC.modalPresentationStyle = .fullScreen
        present(addVC, animated: true)
    }

    func fetchFriends() {
        db.collection("users").document(currentUserUID).getDocument { document, error in
            if let document = document, document.exists,
               let friendUIDs = document.data()?["friends"] as? [String] {
                var fetchedFriends: [Friend] = []
                let group = DispatchGroup()

                for uid in friendUIDs {
                    group.enter()
                    self.db.collection("users").document(uid).getDocument { friendDoc, _ in
                        if let friendDoc = friendDoc, friendDoc.exists {
                            let name = friendDoc.data()? ["displayName"] as? String ?? "Unknown"
                            let email = friendDoc.data()? ["email"] as? String ?? ""
                            fetchedFriends.append(Friend(uid: uid, name: name, email: email))
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    self.friendsList = fetchedFriends
                    self.refreshFriendsUI()
                }
            }
        }
    }
    
    func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(toastLabel)

        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            toastLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 280),
            toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 32)
        ])

        UIView.animate(withDuration: 0.4, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.4, delay: 1.6, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }

    
    func removeFriend(_ friend: Friend) {
        let alert = UIAlertController(
            title: "Remove Friend?",
            message: "Are you sure you want to remove \(friend.name)?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
            self.db.collection("users").document(self.currentUserUID).updateData([
                "friends": FieldValue.arrayRemove([friend.uid])
            ])

            self.db.collection("users").document(friend.uid).updateData([
                "friends": FieldValue.arrayRemove([self.currentUserUID])
            ])

            self.friendsList.removeAll { $0.uid == friend.uid }
            self.friendsTable.reloadData()
            self.showToast(message: "\(friend.name) removed.")
        }))

        present(alert, animated: true)
    }


    func refreshFriendsUI() {
        friendsTable.reloadData()
    }

    func createFriendItem(friend: Friend) -> UIStackView {
        let item = UIStackView()
        item.axis = .horizontal
        item.spacing = 10
        item.alignment = .center
        item.translatesAutoresizingMaskIntoConstraints = false

        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "cafe.png")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.layer.cornerRadius = 25

        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\(friend.name)\n\(friend.email)"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        item.addArrangedSubview(profileImageView)
        item.addArrangedSubview(label)

        return item
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
        
        // TODO: UPDATE PICTURE
        cell?.profilePicture.image = UIImage(named: "cafe.png")
        cell?.nameLabel.text = friend.name
        return cell!
    }
    
    // Swipe-to-remove action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let friend = friendsList[indexPath.row]

        let removeAction = UIContextualAction(style: .destructive, title: "Remove") { _, _, completionHandler in
            self.removeFriend(friend)
            completionHandler(true)
        }

        removeAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [removeAction])
    }

}
