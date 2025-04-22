//
//  ChatCafeViewController.swift
//  BusyBrew
//
//  Created by Nabil Chowdhury on 4/21/25.
//
import UIKit
import Firebase
import FirebaseAuth

class CafeChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    struct ChatMessage {
        let senderId: String
        let senderName: String
        let text: String
        let timestamp: Timestamp
    }

    var messages: [ChatMessage] = []
    let db = Firestore.firestore()

    var cafeId: String = "" // set this before presenting the VC
    var displayName: String = ""

    let tableView = UITableView()
    let messageField = UITextField()
    let sendButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMessages()
    }

    func getTodayKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    func fetchMessages() {
        let todayKey = getTodayKey()
        db.collection("chats").document(cafeId).collection(todayKey).order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let documents = snapshot?.documents {
                    self.messages = documents.compactMap { doc in
                        let data = doc.data()
                        guard let senderId = data["senderId"] as? String,
                              let senderName = data["senderName"] as? String,
                              let text = data["text"] as? String,
                              let timestamp = data["timestamp"] as? Timestamp else { return nil }
                        return ChatMessage(senderId: senderId, senderName: senderName, text: text, timestamp: timestamp)
                    }

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if !self.messages.isEmpty {
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }
            }
    }

    func sendMessage(text: String) {
        guard let currentUser = Auth.auth().currentUser else { return }

        let messageData: [String: Any] = [
            "senderId": currentUser.uid,
            "senderName": displayName,
            "text": text,
            "timestamp": FieldValue.serverTimestamp()
        ]

        let todayKey = getTodayKey()
        db.collection("chats").document(cafeId).collection(todayKey).addDocument(data: messageData)
    }

    func setupUI() {
        title = "Cafe Chat"
        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none

        messageField.borderStyle = .roundedRect
        messageField.placeholder = "Type a message..."
        messageField.delegate = self
        messageField.translatesAutoresizingMaskIntoConstraints = false

        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false

        let inputStack = UIStackView(arrangedSubviews: [messageField, sendButton])
        inputStack.axis = .horizontal
        inputStack.spacing = 8
        inputStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(inputStack)

        NSLayoutConstraint.activate([
            inputStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            inputStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            inputStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            messageField.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputStack.topAnchor, constant: -10)
        ])
    }

    @objc func sendButtonTapped() {
        if let text = messageField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            sendMessage(text: text)
            messageField.text = ""
        }
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let message = messages[indexPath.row]
        cell.textLabel?.text = "\(message.senderName): \(message.text)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTapped()
        return true
    }
}

extension PlaceDetailViewController {
    @objc func openCafeChat() {
        guard let cafe = self.cafe else { return }
        let uid = Auth.auth().currentUser?.uid ?? ""

        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            let displayName = snapshot?.data()? ["displayName"] as? String ?? "Guest"

            let chatVC = CafeChatViewController()
            chatVC.cafeId = cafe.uid
            chatVC.displayName = displayName

            let nav = UINavigationController(rootViewController: chatVC)
            self.present(nav, animated: true)
        }
    }
}
