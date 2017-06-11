//
//  CheckEmailViewController.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 31.05.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit

class CheckEmailViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailBackGroundView: UIView!
    
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailLabel.layer.masksToBounds = false
        self.emailLabel.layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        self.emailLabel.layer.shadowOpacity = 0.5
        self.emailLabel.layer.shadowOffset = CGSize.zero
        self.emailLabel.layer.shadowRadius = 10
        
        var rect = self.emailLabel.bounds
        rect.size.width = self.view.frame.size.width - 22
        
        self.emailLabel.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        self.emailLabel.layer.shouldRasterize = true
        
        self.emailLabel.layer.borderColor = UIColor.white.cgColor
        self.emailLabel.layer.borderWidth = 1

        self.backButton.layer.masksToBounds = true
        self.backButton.layer.cornerRadius = 28
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions

    @IBAction func actionBackButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
