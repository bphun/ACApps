//
//  Reachability.swift
//  ACApps
//
//  Created by Brandon Phan on 5/7/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import ReachabilitySwift
/*
class NetworkReachability {
    
    var reachability: Reachability
    
    func setup() {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
    }

    func reachable() -> Bool {
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        return true
    }
    
    func unreachable() -> Bool {
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                print("Not reachable")
            }
        }
        return true
    }
    
    func startReachabilityNotifier() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    func stopReachabilityNotifier() {
        reachability.stopNotifier()
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
        }
    }
    
    
}
 
 
 */