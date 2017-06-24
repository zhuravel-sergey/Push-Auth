//
//  LoginViewController.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 25.05.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

protocol LoginViewControllerDelegate {
    
    func dismissViewController()
}

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var logoImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailViewBottomConstraint: NSLayoutConstraint!
    
    let actIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    var delegate: LoginViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUserInterface()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.dismissScreen), name: NSNotification.Name(rawValue: "PushAuth"), object: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

            //self.dismissScreen()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Setup Interface

    func setupUserInterface() {
        
        self.actIndicator.center = view.center
        view.addSubview(self.actIndicator)
        
        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 28

        self.emailView.layer.masksToBounds = true
        self.emailView.layer.cornerRadius = 2
        self.emailView.layer.borderWidth = 2
        self.emailView.layer.borderColor = UIColor.white.cgColor
        
        self.emailTextField.delegate = self
        
        if self.view.frame.size.width == 320 {

            self.logoImageHeightConstraint.constant = 120;
            self.logoImageWidthConstraint.constant = 120;
        }
    }
    
    //MARK: Keyboard
    
    func keyboardWillShow() {
        
        if self.view.frame.size.width == 768 || self.view.frame.size.width == 834 {
            self.emailViewBottomConstraint.constant = 250

        } else if self.view.frame.size.width == 1024 {
            self.emailViewBottomConstraint.constant = 300

        } else {
            self.emailViewBottomConstraint.constant = 145
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide() {
        
        self.emailViewBottomConstraint.constant = 56
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func dismissScreen() {
        
        self.dismiss(animated: false, completion: nil)
        self.delegate.dismissViewController()
    }
    
    //MARK: Valid Email
    
    func isValidEmail(email:String) -> Bool {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    //MARK: Actions
    
    @IBAction func actionLoginButton(_ sender: UIButton) {
        
        if UIApplication.shared.isRegisteredForRemoteNotifications {

            if self.emailTextField.text?.characters.count == 0 {
                self.showAlert(title: "Error", message: "E-mail can't be empty.")
                
            } else if !self.isValidEmail(email: self.emailTextField.text!) {
                self.showAlert(title: "Error", message: "Wrong e-mail.")
                
            } else {
                self.requestLogin()
            }
        } else {
            self.showNotificationPopUp()
        }
    }
    
    //MARK: Alert
    
    func showAlert(title:String, message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showCheckEmailPopUp() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckEmailViewController") as! CheckEmailViewController!
        
        vc!.transitioningDelegate = self.transitioningDelegate
        vc!.modalPresentationStyle = .overFullScreen
        vc!.modalTransitionStyle = .crossDissolve
        
        self.present(vc!, animated: true, completion: nil)
    }
    
    func showNotificationPopUp() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationPopUpViewController") as! NotificationPopUpViewController!
        
        vc!.transitioningDelegate = self.transitioningDelegate
        vc!.modalPresentationStyle = .overFullScreen
        vc!.modalTransitionStyle = .crossDissolve
        
        self.present(vc!, animated: true, completion: nil)
    }
    
    //MARK: Webservice
    
    func requestLogin() {
        
        self.actIndicator.startAnimating()
        self.loginButton.isEnabled = false
        
        let parameters: Parameters = ["email": self.emailTextField.text ?? "",
                                      "device_uuid" : (UIDevice.current.identifierForVendor?.uuidString)!,
                                      "device_token" : FIRInstanceID.instanceID().token() ?? "",
                                      "device_type" : "ios"]
        
        let headers = ["Content-Type": "application/json"]
        
        Alamofire.request("https://api.pushauth.io/auth",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers).validate(contentType: ["application/json"]).responseJSON { response in
            //print("Header request:\n \(String(describing: response.request?.allHTTPHeaderFields))\n")
            //print("request httpBody\n",NSString(data: (response.request?.httpBody)!, encoding: String.Encoding.utf8.rawValue) ?? "", "\n")
            //print("Header:\n \(String(describing: response.response?.allHeaderFields))\n")

            switch response.result {
            case .success:
                //print("Validation Successful")

                if let responseJSON = response.result.value {
                    let JSON = responseJSON as! NSDictionary
                    //print("JSON: \(JSON)")
                    
                    if response.response?.statusCode == 200 {
                        
                        DataManager.sharedInstance.userEmail = self.emailTextField.text
                        DataManager.sharedInstance.userPublicKey = JSON["public_key"] as? String

                    } else {
                        if JSON["message"] as! String == "Please check your email for confirmation!" {
                            
                            self.actIndicator.stopAnimating()
                            self.loginButton.isEnabled = true
                            
                            self.showCheckEmailPopUp()
                        } else if JSON["message"] as! String == "Validating error: The device token field is required." {
                            
                            self.requestLogin()
                        }
                    }
                }
            case .failure(let error):
                
                self.showAlert(title: "Error", message: "No internet connection.")
                self.actIndicator.stopAnimating()
                self.loginButton.isEnabled = true
                
                print("Error login", error)
            }
        }
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
