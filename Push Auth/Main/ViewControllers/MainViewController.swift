//
//  MainViewController.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 21.05.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit
import LocalAuthentication
import Alamofire
import CryptoSwift
import SwiftyJSON
import UPCarouselFlowLayout

let pushCellIdentifier = "pushCell"
let codeCellIdentifier = "codeCell"

class MainViewController: UIViewController {
    
    @IBOutlet weak var pushCollectionViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var pushCollectionView: UICollectionView!
    @IBOutlet weak var readyForPushLabel: UILabel!
    @IBOutlet weak var logoClear: UIImageView!
    @IBOutlet weak var newPushLabel: UILabel!
    
    let actIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    var dataPushArray: Array<Push> = []
    var timeTimer:Timer! = Timer()
    var isSendRequest:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pushCollectionView.delegate = self
        self.pushCollectionView.dataSource = self
        
        if self.timeTimer == nil {
            self.timeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timeTimerChanged), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timeTimer, forMode: RunLoopMode.commonModes)
        }
        
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize.init(width: 260, height: 331)
        layout.scrollDirection = .horizontal
        self.pushCollectionView.collectionViewLayout = layout

        self.setupUserInterface()

        if DataManager.sharedInstance.userPublicKey == nil || DataManager.sharedInstance.userPublicKey == "" || DataManager.sharedInstance.userPrivateKey == nil || DataManager.sharedInstance.userPrivateKey == "" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController!
            vc!.delegate = self
            
            DataManager.sharedInstance.isShowPasscode = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.present(vc!, animated: false, completion: nil)
            }
        }
        
        if !(DataManager.sharedInstance.isFirstLaunch!) {
            DataManager.sharedInstance.isFirstLaunch = true
            
            DataManager.sharedInstance.isTouchIdEnable = false
        }

        if DataManager.sharedInstance.userPrivateKey != nil && !(DataManager.sharedInstance.userPrivateKey == "") && DataManager.sharedInstance.userPublicKey != nil && !(DataManager.sharedInstance.userPublicKey == "") {
            
            self.showPasscodeVC()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(self.imageFromColor(color: UIColor.clear, frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 64)), for: .default)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.showPasscodeVC), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.requestGetPush), name: NSNotification.Name(rawValue: "PushRequest"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Setup Interface
    
    func setupUserInterface() {
                
        self.actIndicator.center = view.center
        view.addSubview(self.actIndicator)
        
        self.newPushLabel.isHidden = true
    }
    
    func imageFromColor(color: UIColor, frame: CGRect) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        color.setFill()
        UIRectFill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //MARK: Actions

    @IBAction func actionMenuButton(_ sender: Any) {
        
        self.frostedViewController.presentMenuViewController()
    }
    
    func actionCodeOkButton(index: Int) {
        
        self.dataPushArray.remove(at: index)
        self.pushCollectionView.reloadData()
        
        if self.dataPushArray.count == 0 {
            self.newPushLabel.isHidden = true
            self.logoClear.isHidden = false
            self.readyForPushLabel.isHidden = false
        }
    }
    
    //MARK: Show Passcode VC
    
    func showPasscodeVC() {
        
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
        } else {
            if DataManager.sharedInstance.userPinCode == nil || DataManager.sharedInstance.userPinCode == "" {
                
                self.showCreatePasscodeVC()
            }
        }
        
        if !self.isSendRequest {
            self.requestGetPush()
        }
    }
    
    func showCreatePasscodeVC() {
        
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
    
    //MARK: Webservice
    
    func requestGetPush() {
        
        self.actIndicator.startAnimating()
        self.newPushLabel.isHidden = true
        self.logoClear.isHidden = false
        self.readyForPushLabel.isHidden = false
        self.isSendRequest = true
        self.pushCollectionView.reloadData()
        
        let parameters: Parameters = ["pk": DataManager.sharedInstance.userPublicKey ?? "",
                                      "data" : self.generateDataHash()]
        
        let headers = ["Content-Type": "application/json"]
        
        Alamofire.request("https://api.pushauth.io/push/index", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(contentType: ["application/json"]).responseJSON { response in
            print("Header request:\n \(String(describing: response.request?.allHTTPHeaderFields))\n")
            print("request httpBody\n",NSString(data: (response.request?.httpBody)!, encoding: String.Encoding.utf8.rawValue) ?? "", "\n")
            print("Header:\n \(String(describing: response.response?.allHeaderFields))\n")
            
            switch response.result {
            case .success:
                print("Validation Successful")
                
                if let responseJSON = response.result.value {
                    let JSONdata = responseJSON as! NSDictionary
                    print("JSON: \(JSONdata)")
                    
                    if response.response?.statusCode == 200 {
                        
                        let arrayData = (JSONdata["data"] as! String).components(separatedBy: ".")

                        if arrayData[1] == self.generateHmacWithJson(json: arrayData[0]) {
                            let json = self.convertToDictionary(text: arrayData[0].fromBase64()!)
                            print("json", json ?? "")

                            if !((json?["total"] as! Int) == 0) {
                                if let pushArray = json?["index"] as? [[String:Any]] {
                                    for pushObj in pushArray {
                                        
                                        print(pushObj)
                                        
                                        let push = Push(hashRequest: pushObj["req_hash"] as? String ?? "", mode: pushObj["mode"] as? String ?? "", code: pushObj["code"] as? String ?? "", appName: pushObj["app_name"] as? String ?? "", time: 0)
                                        
                                        self.dataPushArray.append(push)
                                    }
                                }
                            }
                        }
                        
                    } else {
                       
                    }
                }
                
                if !(self.dataPushArray.count == 0) {
                    
                    self.newPushLabel.isHidden = false
                    self.pushCollectionView.reloadData()
                    self.logoClear.isHidden = true
                    self.readyForPushLabel.isHidden = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.isSendRequest = false
                }
                
                self.actIndicator.stopAnimating()
            case .failure(let error):
                
                self.showAlert(title: "Error", message: "No internet connection.")
                self.actIndicator.stopAnimating()
                self.isSendRequest = false
                print("Error login", error)
            }
        }
    }
    
    func requestAnswerPush(index: Int, answer: Bool) {

        self.actIndicator.startAnimating()
        self.pushCollectionView.isUserInteractionEnabled = false
        
        let push = self.dataPushArray[index]
        let json = ["hash":push.hashRequest, "answer": answer] as [String: Any]
        let jsonBase64 = self.dictionaryToBase64(dict: json)
        
        let data = jsonBase64 + "." + self.generateHmacWithJson(json: jsonBase64)
        
        let parameters: Parameters = ["pk": DataManager.sharedInstance.userPublicKey ?? "",
                                      "data" : data]
        
        let headers = ["Content-Type": "application/json"]
        
        Alamofire.request("https://api.pushauth.io/push/answer", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(contentType: ["application/json"]).responseJSON { response in
            print("Header request:\n \(String(describing: response.request?.allHTTPHeaderFields))\n")
            print("request httpBody\n",NSString(data: (response.request?.httpBody)!, encoding: String.Encoding.utf8.rawValue) ?? "", "\n")
            print("Header:\n \(String(describing: response.response?.allHeaderFields))\n")
            
            switch response.result {
            case .success:
                print("Validation Successful")
                
                if let responseJSON = response.result.value {
                    let JSONdata = responseJSON as! NSDictionary
                    print("JSON: \(JSONdata)")
                    
                    if response.response?.statusCode == 200 {
                        
                        self.dataPushArray.remove(at: index)
                        self.pushCollectionView.reloadData()
                        
                        if self.dataPushArray.count == 0 {
                            self.newPushLabel.isHidden = true
                            self.logoClear.isHidden = false
                            self.readyForPushLabel.isHidden = false
                        }
                    } else {
                        
                    }
                }
                
                self.pushCollectionView.isUserInteractionEnabled = true
                self.actIndicator.stopAnimating()
            case .failure(let error):
                
                self.showAlert(title: "Error", message: "No internet connection.")
                self.actIndicator.stopAnimating()
                self.pushCollectionView.isUserInteractionEnabled = true
                print("Error login", error)
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func dictionaryToBase64(dict: [String: Any]) -> String {

        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject:dict,options: JSONSerialization.WritingOptions.prettyPrinted)
            return jsonData.base64EncodedString()
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }
    
    //MARK: Timer
    
    func timeTimerChanged(_ timer:CADisplayLink) {
        
        if !(self.dataPushArray.count == 0) {
            
            for (index, _) in self.dataPushArray.enumerated() {

                self.dataPushArray[index].time += 0.1
            }
            
            for push in self.dataPushArray {
                
                if push.time == 30.0 || push.time > 30.0 {
                    self.dataPushArray.remove(push)
                }
            }
            
            self.pushCollectionView.reloadData()
            self.newPushLabel.isHidden = false
            self.logoClear.isHidden = true
            self.readyForPushLabel.isHidden = true
            
        } else {
            self.newPushLabel.isHidden = true
            self.logoClear.isHidden = false
            self.readyForPushLabel.isHidden = false
        }
    }
    
    //MARK: Alert
    
    func showAlert(title:String, message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Data Hash
    
    func generateDataHash() -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< 32 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        let randomStringBase64 = randomString.toBase64()
        
        let str: [UInt8] = Array(randomStringBase64.utf8)
        let key: [UInt8] = Array(DataManager.sharedInstance.userPrivateKey!.utf8)
        
        let hmac: [UInt8] = try! HMAC(key: key, variant: .sha256).authenticate(str)
        
        let result = hmac.toBase64()!
        
        return String(format: randomStringBase64 + "." + result)
    }
    
    func generateHmacWithJson(json: String) -> String {
        
        let str: [UInt8] = Array(json.utf8)
        let key: [UInt8] = Array(DataManager.sharedInstance.userPrivateKey!.utf8)
        
        let hmac: [UInt8] = try! HMAC(key: key, variant: .sha256).authenticate(str)
        
        return hmac.toBase64()!
    }
}

extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension Array where Element:Equatable {
    public mutating func remove(_ item:Element ) {
        var index = 0
        while index < self.count {
            if self[index] == item {
                self.remove(at: index)
            } else {
                index += 1
            }
        }
    }
    
    public func array( removing item:Element ) -> [Element] {
        var result = self
        result.remove( item )
        return result
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    //MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension MainViewController: UICollectionViewDataSource {
    
    //MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataPushArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let push = self.dataPushArray[indexPath.row]

        if push.mode == "push" {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pushCellIdentifier, for: indexPath) as! PushCollectionViewCell
            
            cell.serviceNameLabel.text = push.appName
            cell.indexCell = indexPath.row
            cell.progressBarView.value = CGFloat(push.time)

            cell.actionYesButtonBlock = { (sender, index) in

                self.requestAnswerPush(index: index, answer: true)
            }
            
            cell.actionNoButtonBlock = { (sender, index) in
                
                self.requestAnswerPush(index: index, answer: false)
            }
            
            return cell
        } else if push.mode == "code" {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: codeCellIdentifier, for: indexPath) as! CodeCollectionViewCell
            
            cell.serviceNameLabel.text = push.appName
            cell.indexCell = indexPath.row
            cell.codeLabel.text = push.code
            cell.progressBarView.value = CGFloat(push.time)
            
            cell.actionOkButtonBlock = { (sender, index) in
                
                self.actionCodeOkButton(index: index)
            }
            
            return cell
        } else {
            return UICollectionViewCell.init()
        }
    }
}

extension MainViewController: LoginViewControllerDelegate {
    
    //MARK: LoginViewControllerDelegate
    
    func dismissViewController() {
        
        if DataManager.sharedInstance.userPinCode == nil || DataManager.sharedInstance.userPinCode == "" {
            
            self.showCreatePasscodeVC()
        }
    }
}

extension MainViewController: SCPinViewControllerCreateDelegate {
    
    //MARK: SCPinViewControllerCreateDelegate

    func pinViewController(_ pinViewController: SCPinViewController!, didSetNewPin pin: String!) {
        
        DataManager.sharedInstance.userPinCode = pin
        self.dismiss(animated: false, completion: nil)
    }
    
    func lengthForPin() -> Int {
        return 4
    }
}

extension MainViewController: SCPinViewControllerValidateDelegate {
    
    //MARK: SCPinViewControllerValidateDelegate

    func pinViewControllerDidSetСorrectPin(_ pinViewController: SCPinViewController!) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func pinViewControllerDidSetWrongPin(_ pinViewController: SCPinViewController!) {
        
    }
}

extension MainViewController: SCPinViewControllerDataSource {
    
    //MARK: SCPinViewControllerDataSource

    func code(for pinViewController: SCPinViewController!) -> String! {
        
        return DataManager.sharedInstance.userPinCode
    }
}
