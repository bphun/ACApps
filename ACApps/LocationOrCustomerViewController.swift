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

            //Display the alert views
            self.alertView.addButton("OK", target: self, selector: Selector("OKButtonPressed:"))
            self.alertView.showInfo("Info", subTitle: "First we have to ask you a question")
        }
    }
    
    //Action when OKButton is pressed on first alert view
    func OKButtonPressed(sender: SCLAlertView) {
        dispatch_async(dispatch_get_main_queue()) {
            //Set up second alert view and show it
            let alertView1 = SCLAlertView()
            alertView1.addButton("Customer of service", target: self, selector: Selector("isUserofService:"))
            alertView1.addButton("Drop off location", target:self, selector: Selector("isDropOffLocation:"))
            alertView1.showEdit("Info", subTitle: "Select who you are")
            self.alertView.hideView()
        }
    }
    
    //Actions for second alert view
    func isDropOffLocation(sender: SCLAlertView) {

        let storyobard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyobard.instantiateViewControllerWithIdentifier("locationSignupViewController") as! UINavigationController
        let navigationController = UINavigationController(rootViewController: VC)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    func isUserofService(sender: SCLAlertView) {
        let VC = (self.storyboard?.instantiateViewControllerWithIdentifier("userSignupViewController"))! as! userSignupViewController
        let navigationController = UINavigationController(rootViewController: VC)
        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
}