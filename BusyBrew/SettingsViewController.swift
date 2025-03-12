//
//  SettingsViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 3/11/25.
//

import UIKit

class SettingsViewController: UIViewController {

    let backButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = background1
        createBackButton()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
