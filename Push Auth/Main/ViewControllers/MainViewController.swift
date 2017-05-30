//
//  MainViewController.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 21.05.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*if DataManager.sharedInstance.userToken == nil || DataManager.sharedInstance.userToken == "" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController!
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
                self.present(vc!, animated: false, completion: nil)
            }
        } */
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
    
    @IBAction func actionMenuButton(_ sender: Any) {
        
        self.frostedViewController.presentMenuViewController()
        
    }

}
