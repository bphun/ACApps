//
//  extensions.swift
//  ACApps
//
//  Created by Brandon Phan on 4/3/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation


//Detect if it is a users first time opening the application
extension NSUserDefaults {
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "firstLaunchFlag"
        let isFirstLaunch = NSUserDefaults.standardUserDefaults().stringForKey(firstLaunchFlag) == nil
        if (isFirstLaunch) {
            NSUserDefaults.standardUserDefaults().setObject("false", forKey: firstLaunchFlag)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        return isFirstLaunch
    }
}