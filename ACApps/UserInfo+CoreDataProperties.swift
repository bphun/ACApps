//
//  UserInfo+CoreDataProperties.swift
//  ACApps
//
//  Created by Brandon Phan on 4/4/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import UIKit
import CoreData

var ManagedObjectContext = [NSManagedObject]()

extension UserInfo {

    @NSManaged var terminateDate: NSDate?
    
    func saveString(string: String, destinationAttribute: String) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity  = NSEntityDescription.entityForName("UserInfo", inManagedObjectContext: managedContext)
        let stringToSave = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        stringToSave.setValue(string, forKey: destinationAttribute)
        
        do {
            try managedContext.save()
            ManagedObjectContext.append(stringToSave)
        } catch let error as NSError {
            print("Error saving string \(error)", "\(error.userInfo)")
        }
        
    }

}
