//
//  Push.swift
//  Push Auth
//
//  Created by Sergey Zhuravel on 17.06.17.
//  Copyright © 2017 Sergey Zhuravel. All rights reserved.
//

import UIKit

class Push: NSObject {

    var hashRequest:String
    var mode:String
    var code:String
    var appName:String
    
    init(hashRequest: String, mode: String, code:String, appName: String) {
        
        self.hashRequest = hashRequest
        self.mode = mode
        self.code = code
        self.appName = appName
    }
}
