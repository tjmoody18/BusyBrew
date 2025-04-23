//
//  SettingsViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 3/11/25.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {
    let db = Firestore.firestore()
    let currentUserEmail = Auth.auth().currentUser?.email ?? ""
    let currentUserUID = Auth.auth().currentUser?.uid ?? ""
    let tightSpacing: [NSAttributedString.Key: Any] = [.kern: -2.0]
    var editMode = false
    
    let editSaveButton = UIButton(type: .system)
    var userTextField = UITextField()
    var passwordTextField = UITextField()
    var emailTextField = UITextField()
    var phoneTextField = UITextField()
    
    var username = "Dummy username"
    var password = "123456"
    var email = "d@gmail.com"
    var phone = "1234567890"
    
    let logoutSegueIdentifier = "LogoutSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = background3
        
        let backButton = createBackButton()
        
        let contentBody = UIView()
        contentBody.translatesAutoresizingMaskIntoConstraints = false
        
        let titleStack = UIStackView()
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        titleStack.axis = .horizontal
        titleStack.alignment = .lastBaseline
        titleStack.distribution = .equalSpacing
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.attributedText = NSAttributedString(string: "Settings", attributes: tightSpacing)
        title.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        title.textColor = background1
        
        editSaveButton.setTitle("Edit", for: .normal)
        editSaveButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        editSaveButton.addTarget(self, action: #selector(editSaveTapped), for: .touchUpInside)
        editSaveButton.backgroundColor = background1
        editSaveButton.setTitleColor(.white, for: .normal)
        editSaveButton.translatesAutoresizingMaskIntoConstraints = false
        editSaveButton.layer.cornerRadius = 5

        titleStack.addArrangedSubview(title)
        titleStack.addArrangedSubview(editSaveButton)
        
        let profileTitle = UILabel()
        profileTitle.translatesAutoresizingMaskIntoConstraints = false
        profileTitle.attributedText = NSAttributedString(string: "Profile Data", attributes: tightSpacing)
        profileTitle.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        profileTitle.textColor = background1
        
        userTextField.text = username
        passwordTextField.text = password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password
        emailTextField.text = email
        phoneTextField.text = phone

        let userTitle = UILabel()
        userTitle.translatesAutoresizingMaskIntoConstraints = false
        userTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        userTitle.textColor = background1Light
        userTitle.text = "Username"

        userTextField.placeholder = "Enter username"
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        userTextField.isEnabled = false
        
        let passTitle = UILabel()
        passTitle.translatesAutoresizingMaskIntoConstraints = false
        passTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        passTitle.textColor = background1Light
        passTitle.text = "Password"

        passwordTextField.placeholder = "Enter password"
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isEnabled = false
        
        let emailTitle = UILabel()
        emailTitle.translatesAutoresizingMaskIntoConstraints = false
        emailTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        emailTitle.textColor = background1Light
        emailTitle.text = "Email"

        emailTextField.placeholder = "Enter email"
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.isEnabled = false
        
        let phoneTitle = UILabel()
        phoneTitle.translatesAutoresizingMaskIntoConstraints = false
        phoneTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        phoneTitle.textColor = background1Light
        phoneTitle.text = "Phone"

        phoneTextField.placeholder = "Enter phone"
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.isEnabled = false
        
        let signoutButton = UIButton()
        signoutButton.setTitle("Logout", for: .normal)
        signoutButton.translatesAutoresizingMaskIntoConstraints = false
        signoutButton.backgroundColor = darkRed
        signoutButton.setTitleColor(.white, for: .normal)
        signoutButton.layer.cornerRadius = 10
        signoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        signoutButton.addTarget(self, action: #selector(signout), for: .touchUpInside)
        
        view.addSubview(contentBody)
        contentBody.addSubview(backButton)
        contentBody.addSubview(titleStack)
        contentBody.addSubview(profileTitle)
        contentBody.addSubview(userTitle)
        contentBody.addSubview(userTextField)
        contentBody.addSubview(passTitle)
        contentBody.addSubview(passwordTextField)
        contentBody.addSubview(emailTitle)
        contentBody.addSubview(emailTextField)
        contentBody.addSubview(phoneTitle)
        contentBody.addSubview(phoneTextField)
        contentBody.addSubview(signoutButton)
        
        
        NSLayoutConstraint.activate([
            contentBody.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentBody.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentBody.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            contentBody.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            contentBody.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
            
            backButton.topAnchor.constraint(equalTo: contentBody.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            
            titleStack.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            titleStack.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
            titleStack.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            
            editSaveButton.widthAnchor.constraint(equalToConstant: 50),
            
            profileTitle.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            profileTitle.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
            profileTitle.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 20),
            
            userTitle.topAnchor.constraint(equalTo: profileTitle.bottomAnchor, constant: 10),
            userTitle.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            userTitle.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
            userTextField.topAnchor.constraint(equalTo: userTitle.bottomAnchor, constant: 5),
            userTextField.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            userTextField.widthAnchor.constraint(equalTo: contentBody.widthAnchor),
            userTextField.heightAnchor.constraint(equalToConstant: 30),
            
            passTitle.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 10),
            passTitle.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            passTitle.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: passTitle.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: contentBody.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30),
            
            emailTitle.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            emailTitle.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            emailTitle.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
            emailTextField.topAnchor.constraint(equalTo: emailTitle.bottomAnchor, constant: 5),
            emailTextField.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            emailTextField.widthAnchor.constraint(equalTo: contentBody.widthAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 30),
            
            phoneTitle.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            phoneTitle.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            phoneTitle.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
            phoneTextField.topAnchor.constraint(equalTo: phoneTitle.bottomAnchor, constant: 5),
            phoneTextField.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            phoneTextField.widthAnchor.constraint(equalTo: contentBody.widthAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 30),
            
            signoutButton.bottomAnchor.constraint(equalTo: contentBody.bottomAnchor, constant: -10),
            signoutButton.leadingAnchor.constraint(equalTo: contentBody.leadingAnchor),
            signoutButton.trailingAnchor.constraint(equalTo: contentBody.trailingAnchor),
            signoutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func editSaveTapped() {
        let isEditing = editSaveButton.titleLabel?.text == "Edit"
        let newTitle  = isEditing ? "Save" : "Edit"
        let newBG = isEditing ? darkRed : background1
        editSaveButton.setTitle(newTitle, for: .normal)
        editSaveButton.backgroundColor = newBG
        
        let textFields = [userTextField, passwordTextField, emailTextField, phoneTextField]
        for tf in textFields {
            tf.isEnabled.toggle()
            if isEditing {
                tf.backgroundColor = .white
                tf.layer.cornerRadius = 5
                tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
                tf.leftViewMode = .always
                // TODO: SAVE INFO IF DONE EDITING
            } else {
                tf.leftViewMode = .never
                tf.backgroundColor = .clear
            }
        }
    }
    
    @objc private func signout() {
        // TODO: ADD SIGNOUT FUNCTIONALITY
        performSegue(withIdentifier: logoutSegueIdentifier, sender: self)
      }

    func createBackButton() -> UIButton {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
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
