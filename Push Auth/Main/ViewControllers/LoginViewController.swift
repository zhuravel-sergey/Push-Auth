//
//  LoginViewController.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 25.05.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Setup Interface

    func setupUserInterface() {
        
        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 28

        self.emailView.layer.masksToBounds = true
        self.emailView.layer.cornerRadius = 2
        self.emailView.layer.borderWidth = 2
        self.emailView.layer.borderColor = UIColor.white.cgColor
        
        self.emailTextField.delegate = self
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField .isEqual(self.emailTextField) {
            
            textField.resignFirstResponder()
            
            self.loginButton.sendActions(for: UIControlEvents.touchUpInside)
        }
        
        return true
    }
}
