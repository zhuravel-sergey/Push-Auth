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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailBackGroundView.layer.masksToBounds = false
        self.emailBackGroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.30).cgColor
        self.emailBackGroundView.layer.shadowOpacity = 1
        self.emailBackGroundView.layer.shadowOffset = CGSize.zero
        self.emailBackGroundView.layer.shadowRadius = 15
        
        self.emailBackGroundView.layer.shadowPath = UIBezierPath(rect: self.emailBackGroundView.bounds).cgPath
        self.emailBackGroundView.layer.shouldRasterize = true
        
        self.emailBackGroundView.layer.borderColor = UIColor.white.cgColor
        self.emailBackGroundView.layer.borderWidth = 1

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
