//
//  LocationOrCustomerViewController.swift
//  ACApps
//
//  Created by Brandon Phan on 4/18/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit

class LocationOrCustomerViewController1: UIViewController {

    let questionareAlertView = SCLAlertView()
    let UserSignupViewController = userSignupViewController()
    let appDelegate = AppDelegate()
    
    internal var isFirstLaunch = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //Determine if it is a user's first time launching the application
            if NSUserDefaults.isFirstLaunch() {
                //User's first time launching the application
                self.isFirstLaunch = true
            } else {
                //Not user's first time launching the application
                self.isFirstLaunch = false
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            
            //Hide UINavigationBar
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            
            //Add a blur effect
            let blurEffect = UIBlurEffect(style: .Dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            UIView.animateWithDuration(1.0, animations: {
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
                    let loginView = UIView()
                    var emailTextField = UITextField()
                    var passwordTextField = UITextField()
                    
                    loginView.frame = CGRectMake(self.view.bounds.width/2, self.view.bounds.height/2, 150, 300)
                    self.view.addSubview(loginView)
                }
            }
            
        }
        
        
    }
    
    
}