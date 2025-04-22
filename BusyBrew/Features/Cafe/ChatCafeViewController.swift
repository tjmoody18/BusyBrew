//
//  CafeChatViewController.swift
//  BusyBrew
//
//  Created by Nabil Chowdhury on 4/21/25.
//m p
import UIKit
import Firebase
import FirebaseAuth

class CafeChatViewController: UIViewController {
  
  struct ChatMessage {
    let senderId: String
    let senderName: String
    let text: String
    let timestamp: Timestamp
  }

  private let tableView = UITableView()
  private let messageField = UITextField()
  private let sendButton = UIButton(type: .system)
  private var inputBottomConstraint: NSLayoutConstraint!
  
  private var messages: [ChatMessage] = []
  private let db = Firestore.firestore()
  var cafeId: String = ""
  var displayName: String = ""
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    fetchMessages()
    registerForKeyboardNotifications()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  
    private func setupUI() {
        title = "Cafe Chat"
        view.backgroundColor = .systemBackground

        // TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.keyboardDismissMode = .interactive

        // Input field & button
        messageField.borderStyle = .roundedRect
        messageField.placeholder = "Type a message…"
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

        // Pin input bar 10 pt above safe area (not 0)
        inputBottomConstraint = inputStack.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -10
        )

        NSLayoutConstraint.activate([
            // tableView fills above the inputStack
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputStack.topAnchor),

            // inputStack
            inputStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            inputStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            inputBottomConstraint,
            messageField.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Initial content inset so bubbles sit 10 pt above the bar
        tableView.contentInset.bottom = 50
        tableView.scrollIndicatorInsets = tableView.contentInset
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard
            let info = note.userInfo,
            let frame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }

        let keyboardHeight = frame.height

        // Slide the input bar up by keyboardHeight + 10 pt gap
        inputBottomConstraint.constant = -keyboardHeight - 10

        // Bump table inset by the same amount
        tableView.contentInset.bottom = 50
        tableView.scrollIndicatorInsets = tableView.contentInset

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ note: Notification) {
        // Restore bar back to -10 pt
        inputBottomConstraint.constant = -10

        // Restore table inset to 40 pt bar + 10 pt gap
        tableView.contentInset.bottom = 50
        tableView.scrollIndicatorInsets = tableView.contentInset

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

  private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    
    NotificationCenter.default.addObserver(self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }

  private func getTodayKey() -> String {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd"
    return f.string(from: Date())
  }
  
  private func fetchMessages() {
    let key = getTodayKey()
    db.collection("chats")
      .document(cafeId)
      .collection(key)
      .order(by: "timestamp")
      .addSnapshotListener { [weak self] snap, _ in
        guard let self = self else { return }
        self.messages = snap?.documents.compactMap { doc in
          let d = doc.data()
          guard let sid = d["senderId"] as? String,
                let sn = d["senderName"] as? String,
                let txt = d["text"] as? String,
                let ts  = d["timestamp"] as? Timestamp
          else { return nil }
          return ChatMessage(senderId: sid, senderName: sn, text: txt, timestamp: ts)
        } ?? []
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
          if !self.messages.isEmpty {
            let ip = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: ip, at: .bottom, animated: true)
          }
        }
      }
  }
  
  private func sendMessage(text: String) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    let data: [String:Any] = [
      "senderId": uid,
      "senderName": displayName,
      "text": text,
      "timestamp": FieldValue.serverTimestamp()
    ]
    let key = getTodayKey()
    db.collection("chats").document(cafeId).collection(key).addDocument(data: data)
  }
  
  
  @objc private func sendButtonTapped() {
    guard let txt = messageField.text?.trimmingCharacters(in: .whitespaces),
          !txt.isEmpty
    else { return }
    sendMessage(text: txt)
    messageField.text = ""
  }
  
}


extension CafeChatViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
    messages.count
  }
  
  func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
    let msg  = messages[ip.row]
    let cell = tv.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: ip) as! ChatMessageCell
    
    cell.nameLabel.text    = msg.senderName
    cell.messageLabel.text = msg.text
    cell.isIncoming        = (msg.senderId != Auth.auth().currentUser?.uid)
    
    let fmt = DateFormatter()
    fmt.timeStyle = .short
    cell.timeLabel.text = fmt.string(from: msg.timestamp.dateValue())
    
    return cell
  }
  
}

extension CafeChatViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ tf: UITextField) -> Bool {
    sendButtonTapped()
    return true
  }
}
