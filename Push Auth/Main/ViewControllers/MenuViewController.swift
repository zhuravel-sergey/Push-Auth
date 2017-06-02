//
//  MenuViewController.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 21.05.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit
import REFrostedViewController

class MenuViewController: UIViewController {
    
    let cellIdentifier = "menuCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    let nameArray = ["Main", "Settings", "Log Out"]
    //let iconArray = ["", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MenuTableViewCell
        
        cell.nameLabel.text = self.nameArray[indexPath.row]
        //cell.iconImageView.image = UIImage.init(named: self.iconArray[indexPath.row])
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let navigationController:MenuNavigationViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuNavigationViewController") as! MenuNavigationViewController
        
        if indexPath.row == 0 {
            
            let wearLevelViewController:MainViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            navigationController.viewControllers = [wearLevelViewController]
            
        }/* else if indexPath.row == 1 {
            
            let baterryDetailsViewController:BaterryDetailsViewController = self.storyboard!.instantiateViewController(withIdentifier: "BaterryDetailsViewController") as! BaterryDetailsViewController
            navigationController.viewControllers = [baterryDetailsViewController]
            
        } else if indexPath.row == 2 {
            
            let deviceInformationViewController:DeviceInformationViewController = self.storyboard!.instantiateViewController(withIdentifier: "DeviceInformationViewController") as! DeviceInformationViewController
            navigationController.viewControllers = [deviceInformationViewController]
            
        } else if indexPath.row == 3 {
            
            let hardwareTestViewController:HardwareTestViewController = self.storyboard!.instantiateViewController(withIdentifier: "HardwareTestViewController") as! HardwareTestViewController
            navigationController.viewControllers = [hardwareTestViewController]
            
        } else if indexPath.row == 5 {
            
            let helpViewController:HelpViewController = self.storyboard!.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
            navigationController.viewControllers = [helpViewController]
            
        } else if indexPath.row == 6 {
            
            let shareViewController:ShareViewController = self.storyboard!.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
            navigationController.viewControllers = [shareViewController]
        } */
        
        self.frostedViewController.contentViewController = navigationController
        self.frostedViewController.hideMenuViewController()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor.clear
    }
}
