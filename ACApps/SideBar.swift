//
//  SideBar.swift
//  SideBar
//
//  Created by Brandon Phan on 2/23/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import UIKit

@objc protocol SideBarDelegate {
    func sideBarDidSelectButtonAtIndex(index: Int)
    optional func sideBarWillClose()
    optional func sideBarWillOpen()
}

class SideBar: NSObject, sideBarTableViewControllerDelegate {
    
    let barWidth: CGFloat = 150.0
    let sideBarTopInset: CGFloat = 64.0
    let sideBarContainerView = UIView()
    let sideBarTableViewController = SideBarTableViewController()
    var originView: UIView!
    var animator = UIDynamicAnimator()
    var delegate: SideBarDelegate?
    var isSideBarOpen = false
    
    var reuseIdentifierString = String()
    
    override init() {
        super.init()
    }
    
    init(sourceView: UIView, menuItem: Array<String>, reuseIdentifier: String! ) {
        super.init()
        originView = sourceView
        
        reuseIdentifierString = reuseIdentifier
        
        sideBarTableViewController.tableData = menuItem
        
        setupSideBar()
        
        animator = UIDynamicAnimator(referenceView: originView)
        
        let showGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        showGestureRecognizer.direction = .Right
        originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        hideGestureRecognizer.direction = .Left
        originView.addGestureRecognizer(hideGestureRecognizer)
    }
    
    func setupSideBar() {
        
        sideBarContainerView.frame = CGRectMake(-barWidth - 1, self.originView.frame.origin.y, barWidth, originView.frame.size.height)
        
        sideBarContainerView.backgroundColor = UIColor.clearColor()
        sideBarContainerView.clipsToBounds = false
        
        originView.addSubview(sideBarContainerView)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        blurView.frame = sideBarContainerView.bounds
        sideBarContainerView.addSubview(blurView)
        
        let tableViewSeparatorBlurView = UIBlurEffect(style: .Dark)
        
        sideBarTableViewController.delegate = self
        sideBarTableViewController.tableView.frame = sideBarContainerView.bounds
        sideBarTableViewController.tableView.clipsToBounds = false
        sideBarTableViewController.tableView.separatorStyle = .SingleLine
        sideBarTableViewController.tableView.separatorEffect = UIVibrancyEffect(forBlurEffect: tableViewSeparatorBlurView)
        sideBarTableViewController.tableView.backgroundColor = UIColor.clearColor()
        sideBarTableViewController.tableView.scrollsToTop = false
        sideBarTableViewController.tableView.contentInset = UIEdgeInsetsMake(sideBarTopInset, 0, 0, 0)
        
        sideBarTableViewController.tableView.reloadData()
        
        sideBarContainerView.addSubview(sideBarTableViewController.tableView)
    }
    
    func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if recognizer.direction == .Left {
            showSideBar(false)
            delegate?.sideBarWillClose?()
            
        } else if recognizer.direction == .Right {
            showSideBar(true)
            delegate?.sideBarWillOpen?()
            
        }
    
    }
    
    func showSideBar(shouldOpen: Bool) {
        animator.removeAllBehaviors()
        isSideBarOpen = shouldOpen
        
        let gravityX: CGFloat = (shouldOpen) ? 0.5 : -0.5
        let maginitude: CGFloat = (shouldOpen) ? 20 : -20
        let boundaryX: CGFloat = (shouldOpen) ? barWidth : -barWidth - 1
        
        let gravityBehavior = UIGravityBehavior(items: [sideBarContainerView])
        gravityBehavior.gravityDirection = CGVectorMake(gravityX, 0)
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [sideBarContainerView])
        collisionBehavior.addBoundaryWithIdentifier("sideBarBoundary", fromPoint: CGPointMake(boundaryX, 20), toPoint: CGPointMake(boundaryX, originView.frame.size.height))
        animator.addBehavior(collisionBehavior)
        
        let pushBehavior = UIPushBehavior(items: [sideBarContainerView], mode: .Instantaneous)
        pushBehavior.magnitude = maginitude
        animator.addBehavior(pushBehavior)
        
        let sideBarBehavior = UIDynamicItemBehavior(items: [sideBarContainerView])
        sideBarBehavior.elasticity = 0.1
        animator.addBehavior(sideBarBehavior)
        
    }
    
    func sideBarControlDidSelectRow(indexPath: NSIndexPath) {
        delegate?.sideBarDidSelectButtonAtIndex(indexPath.row)
    }
    
}
