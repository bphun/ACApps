//
//  SignupViewController.swift
//  ACApps
//
//  Created by Brandon Phan on 3/6/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class userSignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var lastNameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet var textFieldCollection: [TextField]!
    @IBOutlet weak var nextViewcontrollerBarButtonItem: UIBarButtonItem!
    
    var firstName = String()
    var lastName = String()
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable the Right UIBarButtonItem
        nextViewcontrollerBarButtonItem.enabled = false
        
        // Setup the TextFields
        firstNameTextField.delegate = self
        firstNameTextField.returnKeyType = .Continue
        
        lastNameTextField.delegate = self
        lastNameTextField.returnKeyType = .Continue
        
        emailTextField.delegate = self
        emailTextField.returnKeyType = .Done
        
        // Setup NSNotificationCenter to tell us when all text fields have been filled and have text
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userSignupViewController.nextTextField(_:)), name: UIKeyboardWillHideNotification, object: nil)
        firstNameTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        lastNameTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        emailTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    // Check if all text fields have text
    func nextTextField(sender: UITextField) {
        
    }
    
    func textFieldDidChange(sender: UITextField) {
        
        if textFieldCollection[0].text?.utf16.count > 0 && textFieldCollection[1].text?.utf16.count > 0 && textFieldCollection[2].text?.utf16.count > 0 {
            nextViewcontrollerBarButtonItem.enabled = true
        } else {
            nextViewcontrollerBarButtonItem.enabled = false
        }
    }
    
    @IBAction func nextViewcontrollerButton(sender: AnyObject) {
        if nextViewcontrollerBarButtonItem.enabled == true {
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewControllerUsingNavigationController("passwordSetupView", animated: true, CompletionHandler: nil)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController: passwordSetupViewController = segue.destinationViewController as! passwordSetupViewController
        
        destinationViewController.firstName = firstName
        destinationViewController.lastName = lastName
        destinationViewController.email = email                                                       
    }
    
    func presentViewControllerUsingNavigationController(VCId: String, animated: Bool, CompletionHandler: (() -> Void)?){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewControllerWithIdentifier(VCId)
        let navigationController = UINavigationController(rootViewController: VC)
        self.presentViewController(navigationController, animated: animated, completion: CompletionHandler)
    }



}