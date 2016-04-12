//
//  passwordSetupViewController.swift
//  ACApps
//
//  Created by Brandon Phan on 3/12/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class passwordSetupViewController: UIViewController, UITextFieldDelegate {
    
    var firstName = ""
    var lastName = ""
    var email = ""
    
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var confirmPasswordTextField: TextField!
    @IBOutlet var textFieldCollection: [TextField]!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneBarButtonItem.enabled = false
        
        usernameTextField.delegate = self
        usernameTextField.returnKeyType = .Next
        
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .Next
        
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.returnKeyType = .Done

        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)){ () -> Void in
            //Setup NSNotificationCenter to notify us when all textFields are filled
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(passwordSetupViewController.nextTextField(_:)), name: UIKeyboardWillHideNotification, object: nil)
            self.usernameTextField.addTarget(self, action: #selector(passwordSetupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            self.passwordTextField.addTarget(self, action: #selector(passwordSetupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            self.confirmPasswordTextField.addTarget(self, action: #selector(passwordSetupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    
    @IBAction func doneButton(sender: UIBarButtonItem) {

    }
    
    func nextTextField(sender: TextField) {
        
    }
    
    func textFieldDidChange(sender: TextField) {
        for textField in textFieldCollection {
            if textField.text?.utf16.count > 0 {
                doneBarButtonItem.enabled = true
            } else {
                doneBarButtonItem.enabled = false
            }
        }
    }
    
    func createAccount(firstName: String, lastName: String, email: String, username: String, psasword: String) {
        let ref = Firebase(url: "https://acapps.firebaseio.com")
        
        ref.createUser(email, password: passwordTextField.text!) { (error, result) in
            
            if error != nil {
                print("Error creating new user")
            } else {
                let UID = result["uid"] as? String
                print("successfully created user with uid: \(UID)")
            }
            
        }
        
    }
    
 }