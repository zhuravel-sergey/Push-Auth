//
//  SettingsViewController.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 03.06.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingsViewController: UIViewController {

    @IBOutlet weak var changePinCodeButton: UIButton!
    @IBOutlet weak var touchIdSwitch: UISwitch!
    @IBOutlet weak var touchIdView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(self.imageFromColor(color: UIColor.clear, frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 64)), for: .default)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.showPasscodeVC), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }

    func imageFromColor(color: UIColor, frame: CGRect) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        color.setFill()
        UIRectFill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //MARK: Setup Interface
    
    func setupUserInterface() {
     
        self.changePinCodeButton.layer.masksToBounds = true
        self.changePinCodeButton.layer.cornerRadius = 5
        self.changePinCodeButton.layer.borderWidth = 1
        self.changePinCodeButton.layer.borderColor = UIColor.white.cgColor
        
        self.touchIdSwitch.isOn = DataManager.sharedInstance.isTouchIdEnable!
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.touchIdView.isHidden = false
            
            let contextAuth = LAContext()
            var errorAuth: NSError?
            
            if contextAuth.canEvaluatePolicy(.deviceOwnerAuthentication, error: &errorAuth) {
                self.touchIdView.isHidden = false
                
            } else {
                self.touchIdView.isHidden = true
            }
            
            print(errorAuth ?? "")

        } else {
            self.touchIdView.isHidden = true
        }
        
        print(error ?? "")
    }
    
    //MARK: Actions
    
    @IBAction func actionMenuButton(_ sender: Any) {
        
        self.frostedViewController.presentMenuViewController()
    }
    
    @IBAction func actionChangePinCode(_ sender: UIButton) {
        
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
    
    @IBAction func changeValueTouchIdSwitch(_ sender: UISwitch) {
        
        DataManager.sharedInstance.isTouchIdEnable = sender.isOn
    }
    
    //MARK: Show Passcode VC
    
    @objc func showPasscodeVC() {
        
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
            appearance?.titleTextColor = UIColor.white
            appearance?.supportTextColor = UIColor.white
            appearance?.touchIDButtonColor = UIColor.white
            appearance?.touchIDText = "Enter your passcode"
            appearance?.touchIDVerification = "Enter your passcode"
            
            if DataManager.sharedInstance.isTouchIdEnable! {
                appearance?.touchIDButtonEnabled = true
                
            } else {
                appearance?.touchIDButtonEnabled = false
            }
            
            SCPinViewController.setNewAppearance(appearance)
            
            let vc = SCPinViewController.init(scope: .validate)
            vc!.validateDelegate = self
            vc!.dataSource = self
            self.present(vc!, animated: false, completion: nil)
            
            DataManager.sharedInstance.isShowPasscode = false
        }
    }
}

extension SettingsViewController: SCPinViewControllerCreateDelegate {
    
    //MARK: SCPinViewControllerCreateDelegate
    
    func pinViewController(_ pinViewController: SCPinViewController!, didSetNewPin pin: String!) {
        
        DataManager.sharedInstance.userPinCode = pin
        self.dismiss(animated: false, completion: nil)
    }
    
    func lengthForPin() -> Int {
        return 4
    }
}

extension SettingsViewController: SCPinViewControllerValidateDelegate {
    
    //MARK: SCPinViewControllerValidateDelegate
    
    func pinViewControllerDidSetСorrectPin(_ pinViewController: SCPinViewController!) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func pinViewControllerDidSetWrongPin(_ pinViewController: SCPinViewController!) {
        
    }
}

extension SettingsViewController: SCPinViewControllerDataSource {
    
    //MARK: SCPinViewControllerDataSource
    
    func code(for pinViewController: SCPinViewController!) -> String! {
        
        return DataManager.sharedInstance.userPinCode
    }
    
    func hideTouchIDButtonIfFingersAreNotEnrolled() -> Bool {
        
        return true
    }
}
