//
//  NotificationPopUpViewController.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 22.06.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit

class NotificationPopUpViewController: UIViewController {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var backGroundViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backGroundViewLeftConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.iconImageView.layer.masksToBounds = true
        self.iconImageView.layer.cornerRadius = 14

        self.backGroundView.layer.masksToBounds = true
        self.backGroundView.layer.cornerRadius = 10
        
        if self.view.frame.size.width == 768 || self.view.frame.size.width == 1024 || self.view.frame.size.width == 834 {
            self.backGroundViewRightConstraint.constant = 170
            self.backGroundViewLeftConstraint.constant = 170
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.2, animations: {
                
                self.view.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions

    @IBAction func actionCancelButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func actionSettingsButton(_ sender: UIButton) {
        
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appSettings)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
