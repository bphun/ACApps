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

class LocationOrCustomerViewController: UIViewController {
    
    let alertView = SCLAlertView()
    let userSignUpViewController = userSignupViewController()
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_main_queue()) {
            
            //Hide UINavigationBar
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            
            //Add blur effect
            let blurEffect = UIBlurEffect(style: .Dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = self.view.bounds
            
            self.view.addSubview(blurView)

            if NSUserDefaults.isFirstLaunch() {
                //Display the alert views
                self.alertView.addButton("OK", target: self, selector: #selector(LocationOrCustomerViewController.OKButtonPressed(_:)))
                self.alertView.showInfo("Info", subTitle: "First we have to ask you a question")
            } else {
                print("Not first Launch")
            }
        }
    }
    
    //Action when OKButton is pressed on first alert view
    func OKButtonPressed(sender: SCLAlertView) {
        dispatch_async(dispatch_get_main_queue()) {
            //Set up second alert view and show it
            let alertView1 = SCLAlertView()
            alertView1.addButton("Customer of service", target: self, selector: #selector(LocationOrCustomerViewController.isCustomerOfService(_:)))
            alertView1.addButton("Drop off location", target:self, selector: #selector(LocationOrCustomerViewController.isDropOffLocation(_:)))
            alertView1.showEdit("Info", subTitle: "Select who you are")
            self.alertView.hideView()
        }
    }
    
    //Actions for second alert view
    func isDropOffLocation(sender: SCLAlertView) {
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewControllerUsingNavigationController("locationSignupViewController", animated: true, CompletionHandler: nil)
        }
    }
    func isCustomerOfService(Selector: SCLAlertView) {
        self.presentViewControllerUsingNavigationController("UserSignUpViewController", animated: true, CompletionHandler: nil)
    }
 
    func presentViewControllerUsingNavigationController(VCId: String, animated: Bool, CompletionHandler: (() -> Void)?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewControllerWithIdentifier(VCId)
        let navigationController = UINavigationController(rootViewController: VC)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
}



