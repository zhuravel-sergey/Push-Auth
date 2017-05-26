//
//  RootViewController.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 21.05.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit
import REFrostedViewController

class RootViewController: REFrostedViewController {
    
    override func awakeFromNib() {
        
        self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuNavigationViewController")
        self.menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        
    }
}
