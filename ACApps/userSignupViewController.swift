//
//  userSignupViewController.swift
//  ACApps
//
//  Created by Brandon Phan on 4/6/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift
import Firebase

class userSignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var lastNameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var confirmPasswordTextField: TextField!
    @IBOutlet var textFieldCollection: [TextField]!
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    var userFirstName = String()
    var userLastName = String()
    var userEmail = String()
    var userPassword = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Disable the rightUIBarButtonItem
        nextBarButtonItem.enabled = false
        
        //Setup the textFields
        firstNameTextField.delegate = self
        firstNameTextField.returnKeyType = .Next
        
        lastNameTextField.delegate = self
        lastNameTextField.returnKeyType = .Next
        
        emailTextField.delegate = self
        emailTextField.returnKeyType = .Next
        
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .Next
        
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.returnKeyType = .Continue
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { () -> Void in
            // Setup NSNotificationCenter to notify us when all textFields are filled
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userSignupViewController.nextTextField(_:)), name: UIKeyboardWillHideNotification, object: nil)
            self.firstNameTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            self.lastNameTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            self.emailTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            self.passwordTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            self.confirmPasswordTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    
    func nextTextField(sender: TextField) {
        
    }
    
    func textFieldDidChange(sender: TextField) {
        
        for textField in textFieldCollection {
            if textField.text?.utf16.count > 0 && isvalidEmailCheck(emailTextField.text!){
                UIView.animateWithDuration(10.0, animations: {
                    self.nextBarButtonItem.enabled = true
                })
            } else {
                nextBarButtonItem.enabled = false
            }
        }
        
    }

    @IBAction func nextBarButtonItem(sender: UIBarButtonItem) {
        createUserAndPresentNextView()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if getCurrentTextField() == firstNameTextField {
            firstNameTextField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
        } else if getCurrentTextField() == lastNameTextField {
            lastNameTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if getCurrentTextField() == emailTextField {
            emailTextField.resignFirstResponder()
            createUserAndPresentNextView()
        } else if getCurrentTextField() == passwordTextField {
            for textField in textFieldCollection {
                if textField.text == "" {
                    textField.becomeFirstResponder()
                }
            }
            passwordTextField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        }
        return true
    }
    
    func getCurrentTextField() -> TextField {
        
        var currentActiveTextField: TextField!
        
        for textField in textFieldCollection {
            if textField.isFirstResponder() {
                currentActiveTextField = textField
            }
        }
        return currentActiveTextField
    }
    
    func createUserAndPresentNextView() {
        if firstNameTextField.text! != "" && lastNameTextField.text! != "" && emailTextField.text! != "" && passwordTextField.text! != "" && confirmPasswordTextField.text! != "" {
            // All textFields are filled and barButtonItem is enabled
            self.userFirstName = firstNameTextField.text!
            self.userLastName = lastNameTextField.text!
            self.userEmail = emailTextField.text!
            self.userPassword = passwordTextField.text!
            
            // Resign all textFields and create the user
            dispatch_async(dispatch_get_main_queue()) {
                for textField in self.textFieldCollection {
                    if textField.isFirstResponder() {
                        textField.resignFirstResponder()
                    }
                }
                
                self.createUser(self.userEmail, password: self.userPassword, firstName: self.userFirstName, lastName: self.userLastName, completionHandler: { (success) -> Void in
                    if (success) {
                        // Success creating the user, present the next view
                        dispatch_async(dispatch_get_main_queue()) {
                            self.presentView("mapViewViewController", animated: true)
                            print("Show next view")
                        }
                    } else if self.accountCreationError == true {
                    
                        // Error creating the user
                        let accountCreationErrorAlertView = SCLAlertView()
                        accountCreationErrorAlertView.addButton("Ok", action: {
                            accountCreationErrorAlertView.removeFromParentViewController()
                        })
                        accountCreationErrorAlertView.showError("Error", subTitle: "Error creating account")
                    }
                })
            }

        } else {
            // Not all textFields are enabled
        
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueId = "passwordSetupSegue"
        if segue.identifier == segueId {
            print("Prepare for segue: \(segueId)")
            
            if let destinationVC: passwordSetupViewController = segue.destinationViewController as? passwordSetupViewController {
                destinationVC.firstName = userFirstName
                destinationVC.lastName = userLastName
                destinationVC.email = userEmail
            }
        }
    }
    
    func presentView(VCID: String, animated: Bool) {
        let VC = self.storyboard!.instantiateViewControllerWithIdentifier(VCID)
        self.navigationController?.pushViewController(VC, animated: animated)
    }
    
    func isvalidEmailCheck(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
        
    }
    
    typealias CompletionHandler = (success: Bool) -> Void
    var createdUser: Bool!
    var accountCreationError: Bool!
    func createUser(email: String, password: String, firstName: String, lastName: String, completionHandler: CompletionHandler) {
        
        let ref = Firebase(url: "https://acapps.firebaseio.com")
        
        ref.createUser(email, password: password) { (error, result) in
            
            if error != nil {
                print("Error: \(error)")
                self.createdUser = false
                self.accountCreationError = true
            } else {
                print(String(result))
                self.createdUser = true
                self.accountCreationError = false
                completionHandler(success: self.createdUser)
            }
            
        }
        
    }
}
