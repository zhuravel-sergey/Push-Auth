//
//  DataManager.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 25.05.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit

struct ConstantsKeys {
    
    static let kStoredFilename = "storedFilename.gtt"
    
    static let kUserPrivateKey  = "userPrivateKey"
    static let kUserPublicKey  = "userPublicKey"
    static let kUserEmailKey  = "userEmail"
    static let kUserPinCodeKey  = "userPinCode"
    static let kIsShowPasscodeKey  = "isShowPasscode"
}

class DataManager: NSObject {
    
    var userPublicKey:String? {
        didSet {
            self.saveData()
        }
    }
    
    var userPrivateKey:String? {
        didSet {
            self.saveData()
        }
    }
    
    var userEmail:String? {
        didSet {
            self.saveData()
        }
    }
    
    var userPinCode:String? {
        didSet {
            self.saveData()
        }
    }
    
    var isShowPasscode:Bool? {
        didSet {
            self.saveData()
        }
    }
    
    private static var singletonInstance: DataManager!
    
    class var sharedInstance: DataManager! {
        
        get {
            singletonInstance = singletonInstance ?? DataManager()
            return singletonInstance
        }
    }
    
    private override init() {
        super.init()
        
        self.loadData()
    }
    
    func loadData() {
        
        let storedFile = self.filePath()
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: storedFile) {
            
            if let storedSession = NSKeyedUnarchiver.unarchiveObject(withFile: storedFile) as? Dictionary<String, Any> {
                
                self.userPublicKey = storedSession[ConstantsKeys.kUserPublicKey] as! String?
                self.userPrivateKey = storedSession[ConstantsKeys.kUserPrivateKey] as! String?
                self.userEmail = storedSession[ConstantsKeys.kUserEmailKey] as! String?
                self.userPinCode = storedSession[ConstantsKeys.kUserPinCodeKey] as! String?
                self.isShowPasscode = storedSession[ConstantsKeys.kIsShowPasscodeKey] as! Bool?
            }
        }
    }
    
    func saveData() {
        
        let storedFile = self.filePath()
        
        if self.userPublicKey == nil {
            self.userPublicKey = ""
        }
        
        if self.userPrivateKey == nil {
            self.userPrivateKey = ""
        }
        
        if self.userEmail == nil {
            self.userEmail = ""
        }
        
        if self.userPinCode == nil {
            self.userPinCode = ""
        }
        
        if self.isShowPasscode == nil {
            self.isShowPasscode = false
        }
        
        let storedDic = [ConstantsKeys.kUserPublicKey : self.userPublicKey ?? "",
                         ConstantsKeys.kUserPrivateKey : self.userPrivateKey ?? "",
                         ConstantsKeys.kUserEmailKey : self.userEmail ?? "",
                         ConstantsKeys.kUserPinCodeKey : self.userPinCode ?? "",
                         ConstantsKeys.kIsShowPasscodeKey : self.isShowPasscode ?? false] as [String : Any]
        
        NSKeyedArchiver.archiveRootObject(storedDic, toFile: storedFile)
    }
    
    func clearUser() {
        
        self.userPublicKey = ""
        self.userPrivateKey = ""
        self.userEmail = ""
        self.userPinCode = ""
        self.isShowPasscode = false
        self.saveData()
    }
    
    func filePath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory:String = paths[0]
        return (documentsDirectory as NSString).appendingPathComponent(ConstantsKeys.kStoredFilename)
    }
}
