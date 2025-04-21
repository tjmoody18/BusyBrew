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
        
        friendsTable.translatesAutoresizingMaskIntoConstraints = false
        friendsTable.backgroundColor = background3
        friendsTable.estimatedRowHeight = 100
        friendsTable.rowHeight = UITableView.automaticDimension

        contentBody.addArrangedSubview(backButton)
        contentBody.addArrangedSubview(title)
        contentBody.addArrangedSubview(addButton)
        contentBody.addArrangedSubview(friendsTable)

        NSLayoutConstraint.activate([
            contentBody.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentBody.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentBody.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            contentBody.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            contentBody.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
        
            friendsTable.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            friendsTable.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            friendsTable.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
        ])
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
}
