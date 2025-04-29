//
//  FriendRequestsViewController.swift
//  BusyBrew
//
//  Created by Nabil Chowdhury on 4/21/25.
//

import UIKit
import Firebase
import FirebaseAuth

class FriendRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct Request {
        let uid: String
        let name: String
        let email: String
    }

    var requestsList: [Request] = []
    let db = Firestore.firestore()
    let currentUserUID = Auth.auth().currentUser?.uid ?? ""
    let tightSpacing: [NSAttributedString.Key: Any] = [.kern: -2.0]
    let requestsTable = UITableView()
    let cellIdentifier = "FriendRequestCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        requestsTable.dataSource = self
        requestsTable.delegate = self
        requestsTable.register(FriendRequestTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        setupUI()
        fetchRequests()
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
        title.attributedText = NSAttributedString(string: "Incoming Requests", attributes: tightSpacing)
        title.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        title.textColor = background1

        requestsTable.translatesAutoresizingMaskIntoConstraints = false
        requestsTable.backgroundColor = background3
        requestsTable.estimatedRowHeight = 100
        requestsTable.rowHeight = UITableView.automaticDimension

        contentBody.addArrangedSubview(backButton)
        contentBody.addArrangedSubview(title)
        contentBody.addArrangedSubview(requestsTable)

        NSLayoutConstraint.activate([
            contentBody.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentBody.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentBody.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            contentBody.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            contentBody.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),

            requestsTable.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            requestsTable.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            requestsTable.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
        ])
    }

    func fetchRequests() {
        db.collection("users").document(currentUserUID).collection("friendRequests").getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }

            var fetchedRequests: [Request] = []
            let group = DispatchGroup()

            for doc in docs {
                let uid = doc.documentID
                group.enter()
                self.db.collection("users").document(uid).getDocument { userDoc, _ in
                    if let data = userDoc?.data() {
                        let name = data["displayName"] as? String ?? "Unknown"
                        let email = data["email"] as? String ?? ""
                        fetchedRequests.append(Request(uid: uid, name: name, email: email))
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self.requestsList = fetchedRequests
                self.requestsTable.reloadData()
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let request = requestsList[indexPath.row]
        let cell = requestsTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FriendRequestTableViewCell
        cell.configure(name: request.name, email: request.email)
        cell.onAccept = {
            self.acceptTapped(request: request)
        }
        cell.onDeny = {
            self.denyTapped(request: request)
        }
        return cell
    }

    func acceptTapped(request: Request) {
        let requesterUID = request.uid
        db.collection("users").document(currentUserUID).updateData([
            "friends": FieldValue.arrayUnion([requesterUID])
        ])
        db.collection("users").document(requesterUID).updateData([
            "friends": FieldValue.arrayUnion([currentUserUID])
        ])
        db.collection("users").document(currentUserUID)
            .collection("friendRequests")
            .document(requesterUID).delete()

        requestsList.removeAll { $0.uid == requesterUID }
        requestsTable.reloadData()
    }

    func denyTapped(request: Request) {
        let requesterUID = request.uid
        db.collection("users").document(currentUserUID)
            .collection("friendRequests")
            .document(requesterUID).delete()

        requestsList.removeAll { $0.uid == requesterUID }
        requestsTable.reloadData()
    }

}
