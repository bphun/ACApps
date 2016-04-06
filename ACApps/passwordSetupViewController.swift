//
//  passwordSetupViewController.swift
//  ACApps
//
//  Created by Brandon Phan on 3/12/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit

class passwordSetupViewController: UIViewController {
    
    var firstName = String()
    var lastName = String()
    var email = String()
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("First Name: \(firstName)",
              "Last Name: \(lastName)",
              "Email: \(email)")
    }
    
    @IBAction func doneBarButtonItem(sender: AnyObject) {
    }
}