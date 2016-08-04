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
            self.firstNameTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            self.lastNameTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            self.emailTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            self.passwordTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            self.confirmPasswordTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    
    func textFieldDidChange(sender: TextField) {
        
        for textField in textFieldCollection {
            if textField.text?.utf16.count >= 2 && isvalidEmailCheck(emailTextField.text!){
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
            dispatch_async(dispatch_get_main_queue()) {
                self.firstNameTextField.resignFirstResponder()
                self.lastNameTextField.becomeFirstResponder()
            }
        } else if getCurrentTextField() == lastNameTextField {
            dispatch_async(dispatch_get_main_queue()) {
                self.lastNameTextField.resignFirstResponder()
                self.emailTextField.becomeFirstResponder()
            }
        } else if getCurrentTextField() == emailTextField {
            dispatch_async(dispatch_get_main_queue()) {
                self.emailTextField.resignFirstResponder()
                self.passwordTextField.becomeFirstResponder()
            }
        } else if getCurrentTextField() == passwordTextField {
            dispatch_async(dispatch_get_main_queue()) {
                self.passwordTextField.resignFirstResponder()
                self.confirmPasswordTextField.becomeFirstResponder()
            }
        } else if getCurrentTextField() == confirmPasswordTextField {
            dispatch_async(dispatch_get_main_queue()) {
                self.confirmPasswordTextField.resignFirstResponder()
                for textField in self.textFieldCollection {
                    if textField.text == "" {
                        textField.becomeFirstResponder()
                    } else if textField.text != "" {
                        textField.resignFirstResponder()
                        self.createUserAndPresentNextView()
                    }
                }
            }
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
            if passwordTextField.text == confirmPasswordTextField.text {
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
                            
                            let firebaseDataHandling = FirebaseDataHandling()
                            firebaseDataHandling.uploadUserDataToFireBase_User(self.userFirstName, lastName: self.userLastName, Email: self.userEmail, UID: "")
                            
                            // Success creating the user, present the next view
                            self.presentViewControllerUsingNavigationControllerNoReturn("mapViewViewController", animated: true, CompletionHandler: nil)
                            
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
                let darkView = UIView(frame: CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height))
                darkView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
                let alertView = SCLAlertView()
                alertView.addButton("OK", action: {
                    dispatch_async(dispatch_get_main_queue()) {
                        alertView.removeFromParentViewController()
                        alertView.resignFirstResponder()
                        darkView.removeFromSuperview()
                        darkView.resignFirstResponder()
                    }
                })
                self.view.addSubview(darkView)
                alertView.showError("Error", subTitle: "The passwords don't match")
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
                
                let darkView = UIView(frame: CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height))
                darkView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
                let errorAlertView = SCLAlertView()
                errorAlertView.addButton("Okay", action: {
                    
                    UIView.animateWithDuration(5.0, animations: { 
                        dispatch_async(dispatch_get_main_queue()) {
                            errorAlertView.removeFromParentViewController()
                            darkView.removeFromSuperview()
                        }
                    })
                    
                })
                self.view.addSubview(darkView)
                errorAlertView.showError("Error", subTitle: "There was an error creating your account")
                
                self.createdUser = false
                self.accountCreationError = true
            } else {
                print(String(result))
                let firebaseDataHandling = FirebaseDataHandling()
                firebaseDataHandling.uploadUserDataToFireBase_User(firstName, lastName: lastName, Email: email, UID: String(result))
                self.createdUser = true
                self.accountCreationError = false
                completionHandler(success: self.createdUser)
            }
            
        }
        
    }
    func presentViewControllerUsingNavigationControllerNoReturn(VCID: String, animated: Bool, CompletionHandler: (() -> Void)?) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewControllerWithIdentifier(VCID)
            let navigationController = UINavigationController(rootViewController: VC)
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(navigationController, animated: animated, completion: CompletionHandler)
            }
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
