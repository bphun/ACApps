//
//  LocationOrCustomerViewController.swift
//  ACApps
//
//  Created by Brandon Phan on 3/7/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import CryptoSwift
import UIKit

class LocationOrCustomerViewController1: UIViewController {
    
    let alertView = SCLAlertView()
    let userSignUpViewController = userSignupViewController()
    let appDelegate = AppDelegate()
    
    internal var isFirstLaunch = Bool()
    
    let userInfo = UserInfo()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //Determine if it is a users first time opening the application
            if NSUserDefaults.isFirstLaunch() {
                //Is first launch
                self.isFirstLaunch = true
            } else {
                //Not first launch
                self.isFirstLaunch = false  /* <- Change this line <- */
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            
            //Hide UINavigationBar
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            
            //Add blur effect
            let blurEffect = UIBlurEffect(style: .Dark)
            var blurView = UIVisualEffectView()
            blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = self.view.bounds
            UIView.animateWithDuration(0.2, animations: {
                self.view.addSubview(blurView)
            })
            
            if self.isFirstLaunch == true {
                
                //Is first launch
                self.alertView.addButton("OK", target: self, selector: #selector(LocationOrCustomerViewController1.loginButtonPressed(_:)))
                self.alertView.showInfo("Info", subTitle: "Before you begin, we have to ask you a question.")
                
                
                print("First launch")
            } else {
                //Not first launch, Add the login view because it is not the first launch
            
                if self.appDelegate.shouldDisplayLogin == true {
                    print("Wil display map view")
                } else if self.appDelegate.shouldDisplayLogin == false {
                    let loginAlertView = SCLAlertView()
                    //self.alertView.addButton("Create Account", target: self, selector: #selector(<#T##@objc method#>))
                    loginAlertView.addTextField("Username")
                    loginAlertView.addTextField("Password")
                    loginAlertView.addButton("Login", action: {
                        print("Next view")
                    })
                    loginAlertView.showSuccess("Login", subTitle: "")
                }
            }
        }
    }
    
    //Action when Login Button is pressed on first alert view
    func loginButtonPressed(sender: SCLAlertView) {
        dispatch_async(dispatch_get_main_queue()) {
            //Set up second alert view and show it
            let alertView1 = SCLAlertView()
            alertView1.addButton("Customer of service", target: self, selector: #selector(LocationOrCustomerViewController1.isCustomerOfService(_:)))
            alertView1.addButton("Drop off location", target:self, selector: #selector(LocationOrCustomerViewController1.isDropOffLocation(_:)))
            alertView1.showEdit("Info", subTitle: "Select who you are")
            self.alertView.hideView()
        }
    }
    
    //Actions for second alert view
    func isDropOffLocation(sender: SCLAlertView) {
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewControllerUsingNavigationControllerNoReturn("locationSignupViewController", animated: true, CompletionHandler: nil)
        }
    }
    func isCustomerOfService(Selector: SCLAlertView) {
        dispatch_async(dispatch_get_main_queue()) {
            
            self.presentViewControllerUsingNavigationControllerNoReturn("UserSignUpViewController", animated: true, CompletionHandler: nil)
        }
    }
 
    func presentViewControllerUsingNavigationControllerNoReturn(VCID: String, animated: Bool, CompletionHandler: (() -> Void)?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewControllerWithIdentifier(VCID)
        let navigationController = UINavigationController(rootViewController: VC)
        self.presentViewController(navigationController, animated: animated, completion: CompletionHandler)
    }
}



