//
//  ShareData.swift
//  ACApps
//
//  Created by Brandon Phan on 4/7/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation

class ShareData {
    class var SharedInstance: ShareData{
        
        struct Static {
            static var instance: ShareData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ShareData()
        }
        
        return Static.instance!
    }
    
    var someString: String!
    var selectedTheme: AnyObject!
    var someBoolValue: Bool!
}