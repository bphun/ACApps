//
//  LocationOrCustomerViewController.swift
//  ACApps
//
//  Created by Brandon Phan on 4/18/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit
import Spring
import Firebase

class LocationOrCustomerViewController: UIViewController {

    let questionareAlertView = SCLAlertView()
    let UserSignupViewController = userSignupViewController()
    let appDelegate = AppDelegate()
    let loginView = UIView()
    
    var userEmail = String()
    var userPassword = String()
    var textfieldCollection = [UITextField]()
    var canLogin = false
    var buttonLogin = UIButton()
    
    internal var isFirstLaunch = Bool()

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    let animations: [Spring.AnimationPreset] = [
        .Shake,
        .Pop,
        .Morph,
        .Squeeze,
        .Wobble,
        .Swing,
        .FlipX,
        .FlipY,
        .Fall,
        .SqueezeLeft,
        .SqueezeRight,
        .SqueezeDown,
        .SqueezeUp,
        .SlideLeft,
        .SlideRight,
        .SlideDown,
        .SlideUp,
        .FadeIn,
        .FadeOut,
        .FadeInLeft,
        .FadeInRight,
        .FadeInDown,
        .FadeInUp,
        .ZoomIn,
        .ZoomOut,
        .Flash
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //Determine if it is a user's first time launching the application
            if NSUserDefaults.isFirstLaunch() {
                //User's first time launching the application
                self.isFirstLaunch = true
            } else {
                //Not user's first time launching the application
                self.isFirstLaunch = false     /* <- Change line */
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            
            //Hide UINavigationBar
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            
            //Add a blur effect
            let blurEffect = UIBlurEffect(style: .Dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = self.view.bounds
            UIView.animateWithDuration(0.5, animations: {
                self.view.addSubview(blurView)
            })
            
            if (self.isFirstLaunch) {
                //Is first launch
                //self.questionareAlertView.addButton("Okay", target: self, selector: <#T##Selector#>)
                self.questionareAlertView.showInfo("?", subTitle: "Before we begin, we have to ask you a question")
                print("FirstLaunch")
            } else {
                //Not user's first time launching the application, will display the login view
                
                
                if self.appDelegate.shouldDisplayLogin == true {
                    self.presentViewController(MapView(), animated: true, completion: nil)
                } else if self.appDelegate.shouldDisplayLogin == false {
                    
                    let emailTextField = UITextField(frame: CGRectMake(self.loginView.frame.size.width + 40, self.loginView.frame.size.height + 100, 230, 40))
                    let passwordTextField = UITextField(frame: CGRectMake(emailTextField.frame.size.width - 190, emailTextField.frame.size.height + 110, 230, 40))
                    let loginLabel = UILabel(frame: CGRectMake(emailTextField.frame.size.width - 100, emailTextField.frame.size.height - 20, 240, 40))
                    let loginButton = UIButton(frame: CGRectMake(passwordTextField.frame.size.width - 135, passwordTextField.frame.size.height + 168, 100, 30))
                    let createAccountButton = UIButton(frame: CGRectMake(passwordTextField.frame.size.width - 175, loginButton.frame.size.height + 375, 200, 20))
                    
                    self.loginView.layer.cornerRadius = 20
                    self.loginView.frame = CGRectMake(self.view.bounds.size.width/2 - 155, self.view.bounds.size.height/2 - 220, self.view.frame.size.width/1.2, self.view.frame.size.height/1.55)
                    self.loginView.backgroundColor = UIColor.whiteColor()
                    
                    self.textfieldCollection.append(emailTextField)
                    self.textfieldCollection.append(passwordTextField)
                    
                    loginLabel.text = "Login"
                    loginLabel.textColor = UIColor.blackColor()
                    loginLabel.font = loginLabel.font.fontWithSize(25)
                    
                    emailTextField.borderStyle = .RoundedRect
                    emailTextField.placeholder = "User Name"
                    
                    passwordTextField.borderStyle = .RoundedRect
                    passwordTextField.placeholder = "Password"

                    loginButton.setTitle("Login", forState: .Normal)
                    loginButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
                    loginButton.setTitleColor(UIColor.blueColor().colorWithAlphaComponent(0.9), forState: .Highlighted)
                    loginButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
                    loginButton.enabled = false
                    if loginButton.enabled == false {
                        //LoginButton is not enabled
                        loginButton.layer.borderColor = UIColor.grayColor().CGColor
                    } else {
                        //LoginButton is not enabled
                        loginButton.layer.borderColor = UIColor.blueColor().CGColor
                    }
                    loginButton.layer.borderWidth = 1
                    loginButton.layer.cornerRadius = 7
                    loginButton.addTarget(self, action: #selector(LocationOrCustomerViewController.loginButtonPressed(_:)), forControlEvents: .TouchUpInside)
                    
                    createAccountButton.setTitle("Create an account", forState: .Normal)
                    createAccountButton.titleLabel?.font = UIFont.systemFontOfSize(15)
                    createAccountButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                    createAccountButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
                    createAccountButton.addTarget(self, action: #selector(LocationOrCustomerViewController.createAccountButtonPressed(_:)), forControlEvents: .TouchUpInside)
                    self.view.addSubview(self.loginView)

                    self.loginView.addSubview(loginLabel)
                    self.loginView.addSubview(emailTextField)
                    self.loginView.addSubview(passwordTextField)
                    self.loginView.addSubview(loginButton)
                    self.loginView.addSubview(createAccountButton)
                    
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) { () -> Void in
                        self.buttonLogin = loginButton
                        
                        emailTextField.text = self.userEmail
                        passwordTextField.text = self.userPassword
                        
                        emailTextField.addTarget(self, action: #selector(LocationOrCustomerViewController.TextFieldDidChange(_:)), forControlEvents: .EditingChanged)
                        passwordTextField.addTarget(self, action: #selector(LocationOrCustomerViewController.TextFieldDidChange(_:)), forControlEvents: .EditingChanged)
 
                    }
                    
                }
 
            }
            
        }
        
    }
    
    func loginButtonPressed(sender: UIButton) {
        let fireBase = Firebase(url: "acapps.firebaseIO.com")
        print("Login")
        
        fireBase.authUser(userEmail, password: userPassword, withCompletionBlock: { (error, authData) in
            
            if error != nil {
                NSLog("Error creating user %@%", error)
            } else {
                print("Success, login")
            }
            
        })
        
        
    }
    
    func createAccountButtonPressed(sender: UIButton) {
        print("Create account")
    }
    
    func TextFieldDidChange(sender: UITextField) {
        for textField in textfieldCollection {
            if textField.text?.utf16.count > 0 {
                buttonLogin.enabled = true
                buttonLogin.layer.borderColor = UIColor.blueColor().CGColor
            } else {
                buttonLogin.enabled = false
                buttonLogin.layer.borderColor = UIColor.grayColor().CGColor
            }
        }
    }
    
    
}