//  FriendsViewController.swift
//  BusyBrew
import UIKit
import Firebase
import FirebaseAuth

class FriendsViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()
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

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)

        let contentBody = UIStackView()
        contentBody.translatesAutoresizingMaskIntoConstraints = false
        contentBody.axis = .vertical
        contentBody.alignment = .leading
        contentBody.spacing = 10

        scrollView.addSubview(contentBody)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.attributedText = NSAttributedString(string: "Friends", attributes: tightSpacing)
        title.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        title.textColor = background1

        emailField.placeholder = "Enter friend email"
        emailField.borderStyle = .roundedRect
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Friend", for: .normal)
        addButton.backgroundColor = background1
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 5
        addButton.addTarget(self, action: #selector(addFriendTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false

        friendsStack.axis = .vertical
        friendsStack.spacing = 10
        friendsStack.translatesAutoresizingMaskIntoConstraints = false

        contentBody.addArrangedSubview(backButton)
        contentBody.addArrangedSubview(title)
        contentBody.addArrangedSubview(emailField)
        contentBody.addArrangedSubview(addButton)
        contentBody.addArrangedSubview(friendsStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentBody.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentBody.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentBody.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            contentBody.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            contentBody.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -80)
        ])
    }

    @objc func addFriendTapped() {
        let email = emailField.text ?? ""
        if email.isEmpty || currentUserUID.isEmpty {
            showAlert(title: "Error", message: "Please enter a valid email.")
            return
        }

        if email == currentUserEmail {
            showAlert(title: "Invalid", message: "You cannot add yourself as a friend.")
            return
        }

        if friendsList.contains(where: { $0.email == email }) {
            showAlert(title: "Already Friends", message: "You already added this friend.")
            return
        }

        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let snapshot = snapshot, let doc = snapshot.documents.first {
                let friendUID = doc.documentID
                let friendName = doc.data()["displayName"] as? String ?? "Unknown"
                let friendEmail = doc.data()["email"] as? String ?? ""

                self.db.collection("users").document(self.currentUserUID).updateData([
                    "friends": FieldValue.arrayUnion([friendUID])
                ])

                self.db.collection("users").document(friendUID).updateData([
                    "friends": FieldValue.arrayUnion([self.currentUserUID])
                ])

                let newFriend = Friend(uid: friendUID, name: friendName, email: friendEmail)
                self.friendsList.append(newFriend)

                DispatchQueue.main.async {
                    self.friendsStack.addArrangedSubview(self.createFriendItem(friend: newFriend))
                    self.emailField.text = ""
                }

                self.showAlert(title: "Success", message: "Friend added!")
            } else {
                self.showAlert(title: "Error", message: "User not found.")
            }
        }
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
        friendsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for friend in friendsList {
            friendsStack.addArrangedSubview(createFriendItem(friend: friend))
        }
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
}
