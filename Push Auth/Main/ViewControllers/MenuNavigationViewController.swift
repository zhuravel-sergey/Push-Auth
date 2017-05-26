//
//  MenuNavigationViewController.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 21.05.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit
import REFrostedViewController
import UIColor_HexString

class MenuNavigationViewController: UINavigationController {
    
    var isStatusBarHidden:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = self.view.addGestureRecognizer(UIPanGestureRecognizer (target: self, action: #selector(panGestureRecognized(sender:))))
        
        self.frostedViewController.menuViewSize = CGSize(width: 270, height: self.view.frame.size.height)
        self.frostedViewController.limitMenuViewSize = true
        self.frostedViewController.delegate = self
        
        self.navigationBar.setBackgroundImage(UIImage.init(named: "clear"), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.tintColor = UIColor.white
        
        self.isStatusBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func panGestureRecognized(sender: UIPanGestureRecognizer) {
        
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.panGestureRecognized(sender)
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.isStatusBarHidden
    }
}

extension MenuNavigationViewController: REFrostedViewControllerDelegate {
    
    func frostedViewController(_ frostedViewController: REFrostedViewController!, willShowMenuViewController menuViewController: UIViewController!) {
        
        self.isStatusBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func frostedViewController(_ frostedViewController: REFrostedViewController!, willHideMenuViewController menuViewController: UIViewController!) {
        
        self.isStatusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
    }
}
