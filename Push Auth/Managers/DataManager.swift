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
    
    static let kUserToken  = "userToken"
    static let kNotificationToken  = "notificationToken"
}

class DataManager: NSObject {
    
    var userToken:String? {
        didSet {
            self.saveData()
        }
    }
    
    var notificationToken:String? {
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
                
                self.userToken = storedSession[ConstantsKeys.kUserToken] as! String?
                self.notificationToken = storedSession[ConstantsKeys.kNotificationToken] as! String?
            }
        }
    }
    
    func saveData() {
        
        let storedFile = self.filePath()
        
        if self.userToken == nil {
            self.userToken = ""
        }
        
        if self.notificationToken == nil {
            self.notificationToken = ""
        }
        
        let storedDic = [ConstantsKeys.kUserToken : self.userToken ?? "",
                         ConstantsKeys.kNotificationToken : self.notificationToken ?? ""] as [String : Any]
        
        NSKeyedArchiver.archiveRootObject(storedDic, toFile: storedFile)
    }
    
    func filePath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory:String = paths[0]
        return (documentsDirectory as NSString).appendingPathComponent(ConstantsKeys.kStoredFilename)
    }
}
