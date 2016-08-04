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

//Determine if a date is greater, less, or equal to another date
extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}

//Append data to Dictionary with key
extension Dictionary {
    func appendWithKey(destinationDictionary: [String : String], key: String, data: String) -> [String : String] {
        var destinationDictionary = destinationDictionary
        
        if destinationDictionary == ["" : ""] {
            destinationDictionary.startIndex
            destinationDictionary[key] = data
        } else {
            destinationDictionary.popFirst()
            destinationDictionary[key] = data
        }
        
        return destinationDictionary
    }
}


