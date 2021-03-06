//
//  MenuViewController.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 21.05.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit
import REFrostedViewController
import Alamofire

class MenuViewController: UIViewController {
    
    let cellIdentifier = "menuCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    let nameArray = ["Main", "Settings", "Log Out"]
    let iconArray = ["homeIcon", "settingsIcon", "logoutIcon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userEmailLabel.text = DataManager.sharedInstance.userEmail
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestLogOut() {
        
        let parameters: Parameters = ["pk": DataManager.sharedInstance.userPublicKey ?? ""]
        let headers = ["Content-Type": "application/json"]
        
        Alamofire.request("https://api.pushauth.io/logout",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers).validate(contentType: ["application/json"]).responseJSON { response in
                            //print("Header request:\n \(String(describing: response.request?.allHTTPHeaderFields))\n")
                            //print("request httpBody\n",NSString(data: (response.request?.httpBody)!, encoding: String.Encoding.utf8.rawValue) ?? "", "\n")
                            //print("Header:\n \(String(describing: response.response?.allHeaderFields))\n")
                            
                            switch response.result {
                            case .success:
                                //print("Validation Successful")
                                
                                if let responseJSON = response.result.value {
                                    let JSONdata = responseJSON as! NSDictionary
                                    print("JSON: \(JSONdata)")
                                    
                                    if response.response?.statusCode == 200 {
                                        
                                    } else {
                                        
                                    }
                                }
                                
                            case .failure(let error):
                                print("Error login", error)
                            }
        }
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
        cell.iconImageView.image = UIImage.init(named: self.iconArray[indexPath.row])
        cell.selectionStyle = .none
        
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
            
            let mainViewController:MainViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            navigationController.viewControllers = [mainViewController]
            
        } else if indexPath.row == 1 {
            
            let settingsViewController:SettingsViewController = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            navigationController.viewControllers = [settingsViewController]
            
        } else if indexPath.row == 2 {
            
            self.requestLogOut()
            
            DataManager.sharedInstance.clearUser()
            
            let mainViewController:MainViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            navigationController.viewControllers = [mainViewController]
        }
        
        self.frostedViewController.contentViewController = navigationController
        self.frostedViewController.hideMenuViewController()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor.clear
    }
}
