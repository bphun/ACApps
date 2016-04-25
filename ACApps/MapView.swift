//
//  ViewController.swift
//  ACApps
//
//  Created by Brandon Phan on 2/26/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var storyboardMapView: MKMapView!
    @IBOutlet weak var navigationBar: UINavigationItem!

    let xmlParser = XMLParser()
//  let dataFetch = DataFetch()
    var manager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        dispatch_async(dispatch_get_main_queue()) {
            let navigationBarImage = UIImage(named: "CarePackage-Header")
            self.navigationItem.titleView = UIImageView(image: navigationBarImage)
            self.navigationBar.hidesBackButton = true
            
            var gearImage = UIImage(named: "gearIcon")?.imageWithRenderingMode(.AlwaysTemplate)
                        
            let barButtonItem = UIBarButtonItem(image: gearImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MapView.barButtonItemAction(_:)))
            self.navigationBar.leftBarButtonItem = barButtonItem
            
        }
         
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) { () -> Void in
            self.xmlParser.parse({ (success) -> Void in
                if (success) {
                    print("Successful parse")
                }
            })
        }
 
        NSLog("Finish")
    }
    
    func setupMapView() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
            self.manager = CLLocationManager()
            self.manager.delegate = self
            self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.manager.requestAlwaysAuthorization()
            self.manager.requestWhenInUseAuthorization()
            self.manager.startUpdatingLocation()
            
            self.storyboardMapView.scrollEnabled = true
            
            if CLLocationManager.locationServicesEnabled() {
                
                self.storyboardMapView.delegate = self
                self.storyboardMapView.showsUserLocation = true
                self.storyboardMapView.setUserTrackingMode(.None, animated: true)
                
                let span = MKCoordinateSpanMake(0.002, 0.002)
                let location = CLLocationCoordinate2D(latitude: (self.manager.location?.coordinate.latitude)! ,longitude: (self.manager.location?.coordinate.longitude)!)
                let region = MKCoordinateRegion(center: location, span: span)
                self.storyboardMapView.setRegion(region, animated: false)
                
/*
                self.annotation1.title = "Test"
                self.annotation1.coordinate = CLLocationCoordinate2D(latitude: 37.68681389, longitude: -122.11745159)
                self.storyboardMapView.addAnnotation(self.annotation1)
*/
            }
            
            //Add School Pins
            /*
            for school in self.xmlParser.SC_schoolNameArray {
                
                let longitude = String(self.xmlParser.SC_X_CoordinateArray.prefix(1))
                let latitude = String(self.xmlParser.SC_Y_CoordinateArray.prefix(1))
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
                annotation.title = school
                
                self.storyboardMapView.addAnnotation(annotation)
                print("Added pin")
            }
            */
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let reuseID = "pointAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if annotationView == nil {
            /*
            let longitude = String(self.xmlParser.SC_X_CoordinateArray.prefix(1))
            let latitude = String(self.xmlParser.SC_Y_CoordinateArray.prefix(1))
            let schoolName = self.xmlParser.SC_schoolNameArray.prefix(1)
            */
            
            let longitude = -122.23875878
            let latitude = 37.74476469
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
            
            
            mapView.addAnnotation(annotation)
            
            
    } else {
            //we are re-using a view, update its annotation reference...
            annotationView?.annotation = annotation
        }
        return annotationView
    }

    func barButtonItemAction(sender: UIBarButtonItem) {
        print("Bar button item")
    }
    
}
