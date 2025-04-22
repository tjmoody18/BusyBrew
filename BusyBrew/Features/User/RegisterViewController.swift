//
//  RegisterViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 3/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    let backButton = UIButton(type: .system)
    let pageTitle = UILabel()
    let userTextField = UITextField()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let phoneTextField = UITextField()
    let registerButton = UIButton(type: .system)
    let toHomeSegueIdentifier = "RegisterToHomeSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = background1
        createBackButton()
        createTitle()
        createUserField()
        createUsernameField()
        createPasswordField()
        createPhoneField()
        createRegisterButton()
    }

    @objc func registerButtonClicked() {
        guard let email = userTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let username = usernameTextField.text, !username.isEmpty else {
            showAlert(title: "Error", message: "All fields must be filled.")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Registration Failed", message: error.localizedDescription)
                return
            }

            guard let authUid = authResult?.user.uid else { return }

            // Create user document with username
            UserManager().createUserDocument(uid: authUid, email: email, displayName: username)

            DispatchQueue.main.async {
                self.performSegue(withIdentifier: self.toHomeSegueIdentifier, sender: self)
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func createTitle() {
        pageTitle.text = "Register"
        pageTitle.textAlignment = .left
        pageTitle.textColor = .white
        let attributes: [NSAttributedString.Key: Any] = [.kern: -2.0]
        pageTitle.attributedText = NSAttributedString(string: pageTitle.text ?? "", attributes: attributes)
        view.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.font = UIFont.systemFont(ofSize: 80, weight: .semibold)
        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 15),
            pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])

        let subtitle = UILabel()
        let loginButton = UIButton(type: .system)
        subtitle.text = "Already have an account?"
        subtitle.textColor = .white
        subtitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitle)

        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        let buttonAttributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        loginButton.setAttributedTitle(NSAttributedString(string: "Login", attributes: buttonAttributes), for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 15),
            subtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginButton.centerYAnchor.constraint(equalTo: subtitle.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: subtitle.trailingAnchor, constant: 7)
        ])
    }

    func createUserField() {
        let userLabel = UILabel()
        userLabel.text = "Email"
        userLabel.textColor = .white
        userLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userLabel)

        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        userTextField.attributedPlaceholder = NSAttributedString(string: "Enter email", attributes: placeholderAttributes)
        userTextField.backgroundColor = background1Light
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        userTextField.layer.cornerRadius = 10
        userTextField.textColor = .white
        userTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        userTextField.leftViewMode = .always
        userTextField.autocapitalizationType = .none
        userTextField.keyboardType = .emailAddress
        userTextField.autocorrectionType = .no
        view.addSubview(userTextField)

        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 60),
            userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            userTextField.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 5),
            userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            userTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    func createUsernameField() {
        let usernameLabel = UILabel()
        usernameLabel.text = "Username"
        usernameLabel.textColor = .white
        usernameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)

        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Enter username", attributes: placeholderAttributes)
        usernameTextField.backgroundColor = background1Light
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.textColor = .white
        usernameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        usernameTextField.leftViewMode = .always
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .none

        view.addSubview(usernameTextField)

        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 20),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            usernameTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    func createPasswordField() {
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.textColor = .white
        passwordLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordLabel)

        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: placeholderAttributes)
        passwordTextField.backgroundColor = background1Light
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.textColor = .white
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        passwordTextField.leftViewMode = .always
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        view.addSubview(passwordTextField)

        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    func createPhoneField() {
        let phoneLabel = UILabel()
        phoneLabel.text = "Phone Number"
        phoneLabel.textColor = .white
        phoneLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneLabel)

        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "Enter phone number", attributes: placeholderAttributes)
        phoneTextField.backgroundColor = background1Light
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.layer.cornerRadius = 10
        phoneTextField.textColor = .white
        phoneTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        phoneTextField.leftViewMode = .always
        view.addSubview(phoneTextField)

        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 5),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            phoneTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    func createRegisterButton() {
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = background2
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.contentHorizontalAlignment = .center
        registerButton.contentVerticalAlignment = .center
        registerButton.layer.cornerRadius = 10
        registerButton.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        view.addSubview(registerButton)

        NSLayoutConstraint.activate([
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            registerButton.heightAnchor.constraint(equalToConstant: 45),
            registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        ])
    }

    func createBackButton() {
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let attributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        backButton.setAttributedTitle(NSAttributedString(string: "Back", attributes: attributes), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
    }

    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
}
