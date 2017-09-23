//
//  AppDelegate.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 06.05.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        DataManager.sharedInstance.isShowPasscode = true
        DataManager.sharedInstance.requestPushDelay = 1

        UIApplication.shared.statusBarStyle = .lightContent
        
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print("applicationDidEnterBackground")
        
        DataManager.sharedInstance.isShowPasscode = true
        DataManager.sharedInstance.requestPushDelay = 1
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        DataManager.sharedInstance.requestPushDelay = 1

        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
        print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        DataManager.sharedInstance.isShowPasscode = false
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.prod)
        Messaging.messaging().apnsToken = deviceToken
        
        /*
        var pushToken = String(format: "%@", deviceToken as CVarArg)
        pushToken = pushToken.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        pushToken = pushToken.replacingOccurrences(of: " ", with: "")
        
        DataManager.sharedInstance.notificationToken = pushToken
        
        print("Notification token",deviceToken)*/
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        
        let pushData = data as NSDictionary
        
        print("Push notification received: \(pushData)")

        if pushData["mode"] != nil {
            if pushData["mode"] as! String == "auth" {
                
                DataManager.sharedInstance.userPrivateKey = pushData["private_key"] as? String
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushAuth"), object: nil)
                
            } else if pushData["mode"] as! String == "push" || pushData["mode"] as! String == "code" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushRequest"), object: nil)
            }
        }
    }
}

