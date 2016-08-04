//
//  Firebase.swift
//  ACApps
//
//  Created by Brandon Phan on 4/24/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class FirebaseDataHandling {
    
    func uploadUserDataToFireBase_User(firstName: String, lastName: String, Email: String, UID: String) {
        let fireBaseRootRef = Firebase(url: "https://acapps.firebaseio.com")
        let usersRef = fireBaseRootRef.childByAppendingPath("users")

        let userData = ["First Name": firstName, "Last Name": lastName, "Email": Email, "UID": UID]
        
        usersRef.childByAppendingPath(firstName + lastName).setValue(userData)
    }
    
    func uploadUserDataToFireBase_Donator(firstName: String, lastName: String, Email: String, UID: String) {
        let fireBaseRootRef = Firebase(url: "https://acapps.firebaseio.com")
        let usersRef = fireBaseRootRef.childByAppendingPath("Donator")
        
        let userData = ["First Name": firstName, "Last Name": lastName, "Email": Email, "UID": UID]
        
        usersRef.childByAppendingPath(firstName + lastName).setValue(userData)
    }
    
}


/*
 let fireBaseRootRef = Firebase(url: "https://acapps.firebaseio.com")
 var usersRef = fireBaseRootRef.childByAppendingPath("users")
 
 
 
 var alanisawesome = ["full_name": "Alan Turing", "date_of_birth": "June 23, 1912"]
 var gracehop = ["full_name": "Grace Hopper", "date_of_birth": "December 9, 1906"]
 
 
 var users = ["alanisawesome": alanisawesome, "gracehop": gracehop]
 usersRef.setValue(users)
 usersRef.childByAppendingPath("alanisawesome").setValue(alanisawesome)
 usersRef.childByAppendingPath("gracehop").setValue(gracehop)
 
 */