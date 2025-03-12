//
//  RegisterViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 3/11/25.
//

import UIKit

class RegisterViewController: UIViewController {

    let backButton = UIButton(type: .system)
    let pageTitle = UILabel()
    let userTextField = UITextField()
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
        createPasswordField()
        createPhoneField()
        createRegisterButton()
    }
    
    @objc func registerButtonClicked() {
        performSegue(withIdentifier: toHomeSegueIdentifier, sender: self)
    }
    
    func createTitle() {
        pageTitle.text = "Register"
        pageTitle.textAlignment = .left
        pageTitle.textColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: -2.0  // Negative value to reduce the letter spacing
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
        let loginButton = UIButton(type: .system)
        subtitle.text = "Already have an account?"
        subtitle.textColor = .white
        subtitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subtitle)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        let buttonAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        loginButton.titleLabel?.attributedText = NSAttributedString(string: loginButton.titleLabel?.text ?? "", attributes: buttonAttributes)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 15),
            subtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
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
        self.view.addSubview(userLabel)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white  // Set the placeholder color to white
        ]
        userTextField.attributedPlaceholder = NSAttributedString(string: "Enter email", attributes: placeholderAttributes)
                
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
                
        passwordTextField.backgroundColor = background1Light
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.textColor = .white
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        passwordTextField.leftViewMode = .always
        passwordTextField.isSecureTextEntry = true
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
    
    func createPhoneField() {
        let phoneLabel = UILabel()
        phoneLabel.text = "Phone Number"
        phoneLabel.textColor = .white
        phoneLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(phoneLabel)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white  // Set the placeholder color to white
        ]
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "Enter phone number", attributes: placeholderAttributes)
                
        phoneTextField.backgroundColor = background1Light
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.layer.cornerRadius = 10
        phoneTextField.textColor = .white
        phoneTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        phoneTextField.leftViewMode = .always
        self.view.addSubview(phoneTextField)
        
        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
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
        self.view.addSubview(registerButton)
        
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
