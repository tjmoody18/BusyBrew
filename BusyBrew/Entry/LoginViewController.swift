//
//  LoginViewController.swift
//  BusyBrew
//
//  Created by Donald Thai on 3/11/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    let toHomeSegueIdentifier = "LoginToHomeSegue"
    let toRegisterSegueIdentifer = "RegisterSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = background1
        let button = UIButton(type: .system)
        button.setTitle("temp to home", for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        self.view.addSubview(button)
        
        let button2 = UIButton(type: .system)
        button2.setTitle("temp to register", for: .normal)
        button2.frame = CGRect(x: 100, y: 300, width: 200, height: 50)
        button2.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        self.view.addSubview(button2)
    }
    
    @objc func loginButtonClicked() {
        performSegue(withIdentifier: toHomeSegueIdentifier, sender: self)
    }
    
    @objc func registerButtonClicked() {
        performSegue(withIdentifier: toRegisterSegueIdentifer, sender: self)
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
