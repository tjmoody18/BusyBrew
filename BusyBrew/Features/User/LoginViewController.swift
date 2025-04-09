//
//  LoginViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 3/11/25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let backButton = UIButton(type: .system)
    let pageTitle = UILabel()
    let userTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton(type: .system)
    let toHomeSegueIdentifier = "LoginToHomeSegue"
    let toRegisterSegueIdentifer = "RegisterSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = background1
        createBackButton()
        createTitle()
        createUserField()
        createPasswordField()
        createLoginButton()
    }
    
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
    }
    
    @objc func loginButtonClicked() {
        guard let email = userTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty
        else {
            showAlert(title: "Error", message: "Email and password cannot be empty.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Login Failed", message: "Please use a proper username and password. If needed register an account.")
                return
            }
            
            print("User logged in: \(authResult?.user.email ?? "No email")")
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: self.toHomeSegueIdentifier, sender: self)
            }
        }
    }
    
    @objc func registerButtonClicked() {
        performSegue(withIdentifier: toRegisterSegueIdentifer, sender: self)
    }
    
    func createTitle() {
        pageTitle.text = "Login"
        pageTitle.textAlignment = .left
        pageTitle.textColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: -2.0  // reduce the letter spacing
        ]
        pageTitle.attributedText = NSAttributedString(string: pageTitle.text ?? "", attributes: attributes)
        self.view.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.font = UIFont.systemFont(ofSize: 80, weight: .semibold)
        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 15),
            pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        
        let subtitle = UILabel()
        let registerButton = UIButton(type: .system)
        subtitle.text = "Don't have an account?"
        subtitle.textColor = .white
        subtitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subtitle)
        
        registerButton.setTitle("Register now", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        let buttonAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        registerButton.titleLabel?.attributedText = NSAttributedString(string: registerButton.titleLabel?.text ?? "", attributes: buttonAttributes)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        self.view.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 15),
            subtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            registerButton.centerYAnchor.constraint(equalTo: subtitle.centerYAnchor),
            registerButton.leadingAnchor.constraint(equalTo: subtitle.trailingAnchor, constant: 7)
        ])
    }
    
    func createUserField() {
        let userLabel = UILabel()
        userLabel.text = "Email"
        userLabel.textColor = .white
        userLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(userLabel)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white  // Set the placeholder color to white
        ]
        userTextField.attributedPlaceholder = NSAttributedString(string: "Enter email", attributes: placeholderAttributes)
        userTextField.autocapitalizationType = .none
        userTextField.keyboardType = .emailAddress
        userTextField.autocorrectionType = .no
        userTextField.backgroundColor = background1Light
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        userTextField.layer.cornerRadius = 10
        userTextField.textColor = .white
        userTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        userTextField.leftViewMode = .always
        self.view.addSubview(userTextField)
        
        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 60),
            userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            userTextField.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 5),
            userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            userTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func createPasswordField() {
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.textColor = .white
        passwordLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passwordLabel)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white  // Set the placeholder color to white
        ]
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: placeholderAttributes)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.backgroundColor = background1Light
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.textColor = .white
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        passwordTextField.leftViewMode = .always
        self.view.addSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func createLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = background2
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.contentHorizontalAlignment = .center
        loginButton.contentVerticalAlignment = .center
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 45),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        ])
    }
    
    func createBackButton() {
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
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
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
