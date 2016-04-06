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

class userSignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var lastNameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet var textFieldCollection: [TextField]!
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    var firstName = String()
    var lastName = String()
    var email = String()
    
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
        emailTextField.returnKeyType = .Continue
        
        // Setup NSNotificationCenter to notify us when all textFields are filled 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userSignupViewController.nextTextField(_:)), name: UIKeyboardWillHideNotification, object: nil)
        firstNameTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        lastNameTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        emailTextField.addTarget(self, action: #selector(userSignupViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func nextTextField(sender: TextField) {
        
    }
    
    func textFieldDidChange(sender: TextField) {

        for textField in textFieldCollection {
            if textField.text?.utf16.count > 0 {
                nextBarButtonItem.enabled = true
            } else {
                nextBarButtonItem.enabled = false
            }
        }
    }

    @IBAction func nextBarButtonItem(sender: UIBarButtonItem) {
        if nextBarButtonItem.enabled == true {
            dispatch_async(dispatch_get_main_queue()) {
                self.presentView("passwordSetupView", animated: true)
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController: passwordSetupViewController = segue.destinationViewController as! passwordSetupViewController
        
        firstName = firstNameTextField.text!
        lastName = lastNameTextField.text!
        email = emailTextField.text!
        
        destinationViewController.firstName = firstName
        destinationViewController.lastName = lastName
        destinationViewController.email = email
    }
    
    func presentView(VCID: String, animated: Bool) {
        let VC = self.storyboard!.instantiateViewControllerWithIdentifier(VCID)
        self.navigationController?.pushViewController(VC, animated: animated)
    }
    
    
    
}