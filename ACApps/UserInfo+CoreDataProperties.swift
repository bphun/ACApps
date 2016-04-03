//
//  UserInfo+CoreDataProperties.swift
//  ACApps
//
//  Created by Brandon Phan on 4/3/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserInfo {

    @NSManaged var name: String?
    @NSManaged var userName: String?
    @NSManaged var password: String?

}
