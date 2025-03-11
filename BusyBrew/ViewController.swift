//
//  ViewController.swift
//  BusyBrew
//
//  Created by Thomas Moody on 3/7/25.
//

import UIKit

class ViewController: UIViewController {

    let semicircles = UIImageView()
    let subtitle = UILabel()
    let appName = UILabel()
    let rollingBall = UIImageView()
    let getStartedButton = UIButton(type: .system)
    
    let loginSegueIdentifier = "LoginSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = background1
        createTopLeftPicture()
        createSubtitle()
        createTitle()
        createBottomImage()
    }
    
    func createTopLeftPicture() {
        semicircles.image = UIImage(named: "semicircles.svg") // Replace with your image name
        semicircles.contentMode = .scaleAspectFit // Or any other content mode
        self.view.addSubview(semicircles)
        semicircles.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            semicircles.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            semicircles.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
    }
    
    func createSubtitle() {
        subtitle.text = "Find open coffee\nshops, all day any day"
        subtitle.numberOfLines = 2
        subtitle.textAlignment = .right
        subtitle.textColor = .white
        self.view.addSubview(subtitle)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        NSLayoutConstraint.activate([
            subtitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            subtitle.bottomAnchor.constraint(equalTo: semicircles.bottomAnchor)
        ])
    }
    
    func createTitle() {
        appName.text = "BusyBrew"
        appName.textAlignment = .center
        appName.textColor = .white
        appName.font = UIFont.systemFont(ofSize: 80, weight: .semibold)
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: -2.0  // Negative value to reduce the letter spacing
        ]
        appName.attributedText = NSAttributedString(string: appName.text ?? "", attributes: attributes)
        self.view.addSubview(appName)
        appName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appName.topAnchor.constraint(equalTo: semicircles.bottomAnchor, constant: 25),
            appName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            appName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    func createBottomImage() {
        rollingBall.image = UIImage(named: "landingBottom.svg")
        rollingBall.contentMode = .scaleAspectFit
        self.view.addSubview(rollingBall)
        rollingBall.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rollingBall.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: 80),
            rollingBall.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            rollingBall.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        getStartedButton.setTitle("GET STARTED", for: .normal)
        getStartedButton.setTitleColor(.white, for: .normal)
        getStartedButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.view.addSubview(getStartedButton)
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            getStartedButton.topAnchor.constraint(equalTo: rollingBall.topAnchor, constant: 66),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -87)
        ])
        getStartedButton.addTarget(self, action: #selector(getStartedClicked), for: .touchUpInside)
    }
    
    @objc func getStartedClicked() {
        performSegue(withIdentifier: loginSegueIdentifier, sender: self)
    }
}

