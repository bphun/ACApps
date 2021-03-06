//
//  LocationOrCustomerViewController.swift
//  ACApps
//
//  Created by Brandon Phan on 4/18/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift
import Firebase
import ReachabilitySwift
import Spring


class LoginViewController: UIViewController, UITextFieldDelegate {

    let questionareAlertView = SCLAlertView()
    let alertView1 = SCLAlertView()
    let UserSignupViewController = userSignupViewController()
    let appDelegate = AppDelegate()
    let loginView = UIView()
    
    var emailTextField = TextField()
    var passwordTextField = TextField()
    var textfieldCollection = [TextField]()
    var buttonLogin = UIButton()
    let loginButtonColor = UIColor(hex: "66BB6A")
    
    internal var isFirstLaunch = Bool()
    internal var reachableByWIFI = Bool()
    internal var reachableByCellular = Bool()
    internal var unreachable = Bool()
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    //MARK: Setup The View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
         
            //Not user's first time launching the application, will display the login view
            
            if self.appDelegate.shouldDisplayLogin == true { /* Bypass login view, system will login, display main view */
                self.presentViewController(MapView(), animated: true, completion: nil)
                
            } else if self.appDelegate.shouldDisplayLogin == false {    /* The view should display the login view*/
                //MARK: Login view setup
                //Create/setup UI objects
                self.emailTextField = TextField(frame: CGRectMake(self.loginView.frame.size.width + 20, self.loginView.frame.size.height + 100, 290, 40))
                self.passwordTextField = TextField(frame: CGRectMake(self.emailTextField.frame.size.width - 270, self.emailTextField.frame.size.height + 110, 290, 40))
                let loginLabel = UILabel(frame: CGRectMake(self.emailTextField.frame.size.width - 150, self.emailTextField.frame.size.height - 20, 240, 40))
                let loginButton = UIButton(frame: CGRectMake(self.passwordTextField.frame.size.width - 170, self.passwordTextField.frame.size.height + 168, 100, 30))
                let createAccountButton = UIButton(frame: CGRectMake(self.passwordTextField.frame.size.width - 215, loginButton.frame.size.height + 420, 200, 20))
                let resetPasswordButton = UIButton(frame: CGRectMake(loginButton.frame.size.width - 30, loginButton.frame.size.height + 390, 200, 20))
                
                //Setup the loginView
                self.loginView.layer.cornerRadius = 20
                self.loginView.frame = CGRectMake(self.view.bounds.size.width/2 - 175, self.view.bounds.size.height/2 - 250, self.view.frame.size.width/1.2, self.view.frame.size.height/1.55)
                self.loginView.backgroundColor = UIColor.whiteColor()
                
                //Add the textFields to textFieldColection array
                self.textfieldCollection.append(self.emailTextField)
                self.textfieldCollection.append(self.passwordTextField)
                
                //setup the login label
                loginLabel.text = "Login"
                loginLabel.textColor = UIColor(hex: "6A7989")
                loginLabel.font = loginLabel.font.fontWithSize(25)
                
                //Setup emailTextField with required settings
                self.emailTextField.delegate = self
                self.emailTextField.animateViewsForTextDisplay()
                self.emailTextField.placeholder = "Email"
                self.emailTextField.clearButtonMode = .WhileEditing
                self.emailTextField.keyboardType = .EmailAddress
                self.emailTextField.autocorrectionType = .No
                self.emailTextField.autocapitalizationType = .None
                self.emailTextField.returnKeyType = .Next
                self.emailTextField.borderStyle = .Bezel
                self.emailTextField.font = UIFont(name: "Avenir Next", size: 18)
                self.emailTextField.borderInactiveColor = UIColor.blackColor()
                self.emailTextField.borderActiveColor = UIColor(hue: 238, saturation: 42, brightness: 42, alpha: 1)
                self.emailTextField.placeholderColor = UIColor(hex: "6A7989")
                self.emailTextField.textColor = UIColor(hex: "6A7989")
                
                //Setup passwordTextField with required settings
                self.emailTextField.delegate = self
                self.passwordTextField.placeholder = "Password"
                self.passwordTextField.clearButtonMode = .WhileEditing
                self.passwordTextField.autocorrectionType = .No
                self.passwordTextField.autocapitalizationType = .None
                self.passwordTextField.secureTextEntry = true
                self.passwordTextField.returnKeyType = .Done
                self.passwordTextField.borderStyle = .None
                self.passwordTextField.font = UIFont(name: "Avenir Next", size: 18)
                self.passwordTextField.borderInactiveColor = UIColor.blackColor()
                self.passwordTextField.borderActiveColor = UIColor(hue: 238, saturation: 42, brightness: 42, alpha: 1)
                self.passwordTextField.placeholderColor = UIColor(hex: "6A7989")
                self.passwordTextField.textColor = UIColor(hex: "6A7989")
                
                //Setup the login button
                loginButton.setTitle("Login", forState: .Normal)
                loginButton.setTitleColor(self.loginButtonColor, forState: .Normal)
                loginButton.setTitleColor(self.loginButtonColor.colorWithAlphaComponent(0.9), forState: .Highlighted)
                loginButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
                loginButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
                loginButton.enabled = false
                if loginButton.enabled == false {
                    //LoginButton is not enabled
                    loginButton.layer.borderColor = UIColor.lightGrayColor().CGColor
                }
                loginButton.layer.borderWidth = 1.3
                loginButton.layer.cornerRadius = 7
                loginButton.addTarget(self, action: #selector(LoginViewController.loginButtonPressed(_:)), forControlEvents: .TouchUpInside)
                
                //Add a button so that the user can create an account if they have not alrady done so
                createAccountButton.setTitle("Create an account", forState: .Normal)
                createAccountButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
                createAccountButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                createAccountButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
                createAccountButton.addTarget(self, action: #selector(LoginViewController.createAccountButtonPressed(_:)), forControlEvents: .TouchUpInside)
                
                //Add a button so that a user can reset their password
                resetPasswordButton.setTitle("Reset Password", forState: .Normal)
                resetPasswordButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
                resetPasswordButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                resetPasswordButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
                resetPasswordButton.addTarget(self, action: #selector(LoginViewController.resetPasswordButtonPressed(_:)), forControlEvents: .TouchUpInside)
                
                //Add loginView as a subview to the view controller
                UIView.transitionWithView(self.view, duration: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { 
                    self.view.addSubview(self.loginView)
                    }, completion: nil)
                
                
                //Add loginView UI as a subview of loginView
                self.loginView.addSubview(loginLabel)
                self.loginView.addSubview(self.emailTextField)
                self.loginView.addSubview(self.passwordTextField)
                self.loginView.addSubview(loginButton)
                self.loginView.addSubview(createAccountButton)
                self.loginView.addSubview(resetPasswordButton)
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { () -> Void in
                    //Assign buttonLogin to loginButton to make it globally accessible
                    self.buttonLogin = loginButton
                    
                    //Add observer to notify us when the text field text changes
                    self.emailTextField.addTarget(self, action: #selector(LoginViewController.TextFieldDidChange(_:)), forControlEvents: .EditingChanged)
                    self.passwordTextField.addTarget(self, action: #selector(LoginViewController.TextFieldDidChange(_:)), forControlEvents: .EditingChanged)
                    
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
                }
            }
        }
    }

    //MARK: Alert view actions
    func firstAlertViewAction(sender: SCLAlertView) {
        dispatch_async(dispatch_get_main_queue()) {
            //Create the second alert view
            self.questionareAlertView.removeFromParentViewController()
            self.alertView1.addButton("Customer of Service", target: self, selector: #selector(LoginViewController.isCustomerOfService(_:)))
            self.alertView1.addButton("Drop off Location", target: self, selector: #selector(LoginViewController.isDonator(_:)))
            self.alertView1.showEdit("?", subTitle: "Will you be a:")
        }
    }

    func isCustomerOfService(sender: SCLAlertView) {
        dispatch_async(dispatch_get_main_queue()) {
            self.alertView1.removeFromParentViewController()
            self.presentViewControllerUsingNavigationControllerNoReturn("UserSignUpViewController", animated: true, CompletionHandler: nil)
        }
    }
    func isDonator(sender: SCLAlertView) {
        dispatch_async(dispatch_get_main_queue()) {
            self.alertView1.removeFromParentViewController()
            self.presentViewControllerUsingNavigationControllerNoReturn("DonatorSignUpViewController", animated: true, CompletionHandler: nil)
        }
    }
 
    
    
    //MARK: Methods
    //Action for the loginButton
    func loginButtonPressed(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //Create Firebase reference object
            let fireBaseRef = Firebase(url: "https://acapps.firebaseio.com")
            
            //Authorize the user through fireBaseRef
            fireBaseRef.authUser(self.getTextFieldText(self.emailTextField), password: self.getTextFieldText(self.passwordTextField)) { (error, authData) in
                
                //Handle an error if one occurs
                if error != nil {
                    
                    print(error)
                    
                    let darkView = UIView(frame: CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height))

                    let errorAlertView = SCLAlertView()
                    errorAlertView.addButton("OK", action: {
                        dispatch_async(dispatch_get_main_queue()) {
                            UIView.animateWithDuration(5.0, animations: {
                                darkView.resignFirstResponder()
                                darkView.removeFromSuperview()
                                errorAlertView.removeFromParentViewController()
                                errorAlertView.resignFirstResponder()
                            })
                        }
                    })
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.view.endEditing(true)
                        darkView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
                        
                        self.view.addSubview(darkView)
                        errorAlertView.showError("Error", subTitle: "Error logging in")
                    }
                
                    
                } else if authData != nil { /* Login success, print the authorization data specific to the user, display main view */
                    dispatch_async(dispatch_get_main_queue()) {
                        self.view.endEditing(true)
                        self.presentViewControllerUsingNavigationControllerNoReturn("mapViewViewController", animated: true, CompletionHandler: nil)
                        //self.presentView("mapViewViewController", animated: true)
                    }
                }
            }
        }
    }
    //Method to handle password reset button
    func resetPasswordButtonPressed(sender: UIButton) {
        let fireBaseRef = Firebase(url: "acapps.firebaseIO.com")
        
        let darkView = UIView(frame: CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height))
        darkView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        
        let emailAlertView = SCLAlertView()
        let emailTextField = emailAlertView.addTextField("Email:")
        emailAlertView.addButton("Okay") {
            UIView.animateWithDuration(10.0, animations: {
                darkView.resignFirstResponder()
                darkView.removeFromSuperview()
                emailAlertView.removeFromParentViewController()
            })
            
            fireBaseRef.resetPasswordForUser(emailTextField.text) { (error) in
                
                if error != nil {
                    //Error resetting user password
                    let errorAlertView = SCLAlertView()
                    errorAlertView.addButton("Okay", action: {
                        UIView.animateWithDuration(10.0, animations: {
                            darkView.removeFromSuperview()
                            darkView.resignFirstResponder()
                            errorAlertView.removeFromParentViewController()
                        })
                    })
                    errorAlertView.addButton("Retry", action: {
                        emailAlertView.showEdit("Reset Password", subTitle: "Please enter your email so that we can help you reset you password")
                    })
                    
                } else {
                    //Success resetting user password
                    let successAlertView = SCLAlertView()
                    successAlertView.addButton("Okay", action: {
                        UIView.animateWithDuration(10.0, animations: {
                            successAlertView.removeFromParentViewController()
                            darkView.removeFromSuperview()
                        })
                    })
                    self.view.addSubview(darkView)
                    successAlertView.showSuccess("Success", subTitle: "We have sent you an email so that you can reset your password")
                }
            }
        }
        self.view.addSubview(darkView)
        emailAlertView.showEdit("Reset Password", subTitle: "Please enter your email so that we can help you reset you password")
        
    }
    //Action for the createAccountButton
    func createAccountButtonPressed(sender: UIButton) {
        self.loginView.resignFirstResponder()
        self.loginView.removeFromSuperview()
        
        self.questionareAlertView.addButton("Okay", target: self, selector: #selector(LoginViewController.firstAlertViewAction(_:)))
        self.questionareAlertView.showInfo("?", subTitle: "Before we begin, we have to ask you a question")
    }
    //Method used to retrieve text from a specified UITextField, allows you to not have to declare an object for the text
    func getTextFieldText(textField: TextField) -> String {
        let textFieldString = textField.text
        return textFieldString!
    }
    //Method used to get the current active UITextField
    func getCurrentTextField() -> TextField {
        var currentActiveTextField: TextField!
        
        for textField in self.textfieldCollection {
            if textField.isFirstResponder() {
                currentActiveTextField = textField
            }
        }
        return currentActiveTextField
    }
    //Method used to detect when user taps return button on UIKeyboard and make the next UITextField in the view become the first responder
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if getCurrentTextField() == emailTextField {
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
        } else if getCurrentTextField() == passwordTextField {
            if buttonLogin.enabled == true {
                passwordTextField.resignFirstResponder()
                self.presentView("mapViewViewController", animated: true)
                self.view.endEditing(true)
            } else {
                self.emailTextField.becomeFirstResponder()
            }
        }
        return true
    }
    //Method used to detect when all UITextFields have text and enable the loginButton
    func TextFieldDidChange(sender: UITextField) {
        dispatch_async(dispatch_get_main_queue()) {
            for textField in self.textfieldCollection {
                if textField.text?.utf16.count > 0 && self.isvalidEmailCheck(self.emailTextField.text!) {
                    self.buttonLogin.enabled = true
                    self.buttonLogin.layer.borderColor = self.loginButtonColor.CGColor

                } else {
                    self.buttonLogin.enabled = false
                    self.buttonLogin.layer.borderColor = UIColor.lightGrayColor().CGColor
                }
            }
        }
    }
    func isvalidEmailCheck(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
        
    }
    func keyboardWillShow(sender: NSNotification) {
        UIView.animateWithDuration(0.5, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.loginView.frame = CGRectMake(self.view.bounds.size.width/2 - 175, self.view.bounds.size.height/2 - 335, self.view.frame.size.width/1.2, self.view.frame.size.height/1.55)
            }, completion: nil)
    }
    func keyboardWillHide(sender: NSNotification) {
        UIView.animateWithDuration(0.5, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.loginView.frame = CGRectMake(self.view.bounds.size.width/2 - 175, self.view.bounds.size.height/2 - 250, self.view.frame.size.width/1.2, self.view.frame.size.height/1.55)
            }, completion: nil)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Method used to present a specified view
    func presentView(VCID: String, animated: Bool) {
        let VC = self.storyboard!.instantiateViewControllerWithIdentifier(VCID)
        self.navigationController?.pushViewController(VC, animated: animated)
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
    
    
    
}