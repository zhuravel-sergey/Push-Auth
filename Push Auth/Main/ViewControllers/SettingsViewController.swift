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

        } else {
            self.touchIdView.isHidden = true
        }
        
        let contextAuth = LAContext()
        var errorAuth: NSError?
        
        if contextAuth.canEvaluatePolicy(.deviceOwnerAuthentication, error: &errorAuth) {
            self.touchIdView.isHidden = false
            
        } else {
            self.touchIdView.isHidden = true
        }
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
