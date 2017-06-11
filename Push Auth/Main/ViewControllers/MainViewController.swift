//
//  MainViewController.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 21.05.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit
import LocalAuthentication

class MainViewController: UIViewController {

    @IBOutlet weak var requestBackGroudnView: UIView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var progressBarView: MBCircularProgressBarView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    let actIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUserInterface()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.showPasscodeVC), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

        if DataManager.sharedInstance.userPublicKey == nil || DataManager.sharedInstance.userPublicKey == "" || DataManager.sharedInstance.userPrivateKey == nil || DataManager.sharedInstance.userPrivateKey == "" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController!
            vc!.delegate = self
            
            DataManager.sharedInstance.isShowPasscode = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.present(vc!, animated: false, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(self.imageFromColor(color: UIColor.clear, frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 64)), for: .default)
        
        if DataManager.sharedInstance.userPrivateKey != nil && !(DataManager.sharedInstance.userPrivateKey == "") && DataManager.sharedInstance.userPublicKey != nil && !(DataManager.sharedInstance.userPublicKey == "") {
            
            self.showPasscodeVC()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Setup Interface
    
    func setupUserInterface() {
        
        self.actIndicator.center = view.center
        view.addSubview(self.actIndicator)
        
        self.requestBackGroudnView.layer.masksToBounds = true
        self.requestBackGroudnView.layer.cornerRadius = 10
        
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 48, height: self.requestBackGroudnView.frame.height))
        self.requestBackGroudnView.layer.shadowColor = UIColor.black.cgColor
        self.requestBackGroudnView.layer.shadowOffset = CGSize(width: 0, height: 25)
        self.requestBackGroudnView.layer.shadowOpacity = 0.5
        self.requestBackGroudnView.layer.shadowRadius = 10.0
        self.requestBackGroudnView.layer.masksToBounds =  false
        self.requestBackGroudnView.layer.shadowPath = shadowPath.cgPath
        
        self.yesButton.layer.masksToBounds = true
        self.yesButton.layer.cornerRadius = 26.5
        
        self.noButton.layer.masksToBounds = true
        self.noButton.layer.cornerRadius = 26.5
    }
    
    func imageFromColor(color: UIColor, frame: CGRect) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        color.setFill()
        UIRectFill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //MARK: Actions

    @IBAction func actionMenuButton(_ sender: Any) {
        
        self.frostedViewController.presentMenuViewController()
    }
    
    @IBAction func actionYesButton(_ sender: UIButton) {
        
        
    }
    
    @IBAction func actionNoButton(_ sender: UIButton) {
        
        
    }
    
    //MARK: Show Passcode VC
    
    func showPasscodeVC() {
        
        if DataManager.sharedInstance.isShowPasscode! && DataManager.sharedInstance.userPinCode != nil && !(DataManager.sharedInstance.userPinCode == "") {
            
            let appearance = SCPinAppearance.default()
            appearance?.titleText = "Enter PIN-code";
            appearance?.numberButtonColor = UIColor.white
            appearance?.numberButtonTitleColor = UIColor.white
            appearance?.numberButtonStrokeColor = UIColor.white
            appearance?.deleteButtonColor = UIColor.white
            appearance?.pinFillColor = UIColor.clear
            appearance?.pinHighlightedColor = UIColor.white
            appearance?.pinStrokeColor = UIColor.white
            appearance?.touchIDButtonEnabled = false
            appearance?.titleTextColor = UIColor.white
            appearance?.supportTextColor = UIColor.white
            appearance?.touchIDButtonEnabled = true
            appearance?.touchIDButtonColor = UIColor.white
            appearance?.touchIDText = "Enter your passcode"
            appearance?.touchIDVerification = "Enter your passcode"
            SCPinViewController.setNewAppearance(appearance)
            
            let vc = SCPinViewController.init(scope: .validate)
            vc!.validateDelegate = self
            vc!.dataSource = self
            self.present(vc!, animated: false, completion: nil)
            
            DataManager.sharedInstance.isShowPasscode = false
        } else {
            if DataManager.sharedInstance.userPinCode == nil || DataManager.sharedInstance.userPinCode == "" {
                
                self.showCreatePasscodeVC()
            }
        }
    }
    
    func showCreatePasscodeVC() {
        
        let appearance = SCPinAppearance.default()
        appearance?.titleText = "Create PIN-code";
        appearance?.numberButtonColor = UIColor.white
        appearance?.numberButtonTitleColor = UIColor.white
        appearance?.numberButtonStrokeColor = UIColor.white
        appearance?.deleteButtonColor = UIColor.white
        appearance?.pinFillColor = UIColor.clear
        appearance?.pinHighlightedColor = UIColor.white
        appearance?.pinStrokeColor = UIColor.white
        appearance?.touchIDButtonEnabled = false
        appearance?.titleTextColor = UIColor.white
        appearance?.supportTextColor = UIColor.white
        SCPinViewController.setNewAppearance(appearance)
        
        let vc = SCPinViewController.init(scope: .create)
        vc!.createDelegate = self
        self.present(vc!, animated: false, completion: nil)
    }
}

extension MainViewController: LoginViewControllerDelegate {
    
    //MARK: LoginViewControllerDelegate
    
    func dismissViewController() {
        
        if DataManager.sharedInstance.userPinCode == nil || DataManager.sharedInstance.userPinCode == "" {
            
            self.showCreatePasscodeVC()
        }
    }
}

extension MainViewController: SCPinViewControllerCreateDelegate {
    
    //MARK: SCPinViewControllerCreateDelegate

    func pinViewController(_ pinViewController: SCPinViewController!, didSetNewPin pin: String!) {
        
        DataManager.sharedInstance.userPinCode = pin
        self.dismiss(animated: false, completion: nil)
    }
    
    func lengthForPin() -> Int {
        return 4
    }
}

extension MainViewController: SCPinViewControllerValidateDelegate {
    
    //MARK: SCPinViewControllerValidateDelegate

    func pinViewControllerDidSetСorrectPin(_ pinViewController: SCPinViewController!) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func pinViewControllerDidSetWrongPin(_ pinViewController: SCPinViewController!) {
        
    }
}

extension MainViewController: SCPinViewControllerDataSource {
    
    //MARK: SCPinViewControllerDataSource

    func code(for pinViewController: SCPinViewController!) -> String! {
        
        return DataManager.sharedInstance.userPinCode
    }
}
