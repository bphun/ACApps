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

    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextBarButtonItem.enabled = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.navigationItem.leftBarButtonItem?.title = "title"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
        
        firstNameTextField.delegate = self
        firstNameTextField.returnKeyType = .Continue
        
        lastNameTextField.delegate = self
        lastNameTextField.returnKeyType = .Continue
        
        emailTextField.delegate = self
        emailTextField.returnKeyType = .Done
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("nextTextField:"), name: UIKeyboardWillHideNotification, object: nil)
        firstNameTextField.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        lastNameTextField.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        emailTextField.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func textFieldDidChange(sender: UITextField) {
        
        if (firstNameTextField.text?.utf16.count > 0 && lastNameTextField.text?.utf16.count > 0 && emailTextField.text?.utf16.count > 0) {
            nextBarButtonItem.enabled = true
        } else {
            nextBarButtonItem.enabled = false
        }
    }
    
    @IBAction func nextViewButton(sender: UIBarButtonItem) {

        dispatch_async(dispatch_get_main_queue()) {
            
            let storyoboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyoboard.instantiateViewControllerWithIdentifier("userPasswordSetupView")
            let navigationController = UINavigationController(rootViewController: VC)
            self.presentViewController(navigationController, animated: true, completion: nil)
            
        }
        
    }



}