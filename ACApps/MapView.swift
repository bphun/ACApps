//
//  MapView.swift
//  ACApps
//
//  Created by Brandon Phan on 4/25/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class MapView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var mapStylePicker: UISegmentedControl!
    
    let xmlParser = XMLParser()
    var hospitalDataArray = [String]()
    var schoolDataArray = [String]()
    
    let manager = CLLocationManager()
    
    var location: String!
    var address: String!
    var annotationLat: String!
    var annotationLong: String!
    var annotationData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_main_queue()) {
            let navBarImage = UIImage(named: "CarePackage-Header")
            self.navigationItem.titleView = UIImageView(image: navBarImage)
            self.navigationBar.hidesBackButton = true
            
/*
            let barButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(MapView.barButtonAction(_:)))
            self.navigationBar.leftBarButtonItem = barButtonItem
            self.mapStylePicker.selectedSegmentIndex = 0
 */
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) { () -> Void in
            

            self.xmlParser.parse({ (success) in
                if success == true {
                    self.hospitalDataArray = self.xmlParser.hospitalDataArray
                    self.schoolDataArray = self.xmlParser.schoolDataArray
                    print("Successful parse")
                    
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
                        let dataArray = [self.schoolDataArray]
    
                        for array in dataArray {
                            if array.isEmpty {
                                print("Error: ", "Array is empty")
                            } else {
                                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
                                    
                                    let annotationArray = self.getMapAnnotations(array)
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.mapView.addAnnotations(annotationArray)
                                    }
                                }
                            }
                        }
                    }
                }
            })
            dispatch_async(dispatch_get_main_queue()) {
                self.setupMapView()
            }
        }
    }
    
    func setupMapView() {
    
        self.manager.delegate = self
        self.mapView.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.requestAlwaysAuthorization()
        self.manager.startUpdatingLocation()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.showsUserLocation = true
            self.mapView.userLocationVisible
            self.mapView.scrollEnabled = true
            self.mapView.zoomEnabled = true
            self.mapView.userInteractionEnabled = true
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            self.mapView.showsScale = true
            self.mapView.showsCompass = true

        }
    }
    
    @IBAction func segmentedControllerDidChange(sender: UISegmentedControl) {
        switch mapStylePicker.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = .Standard
        case 1:
            self.mapView.mapType = .Hybrid
        case 2:
            self.mapView.mapType = .Satellite
        default:
            self.mapView.mapType = .Standard
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        
        self.mapView.setRegion(region, animated: true)
        
        self.mapView.setUserTrackingMode(.None, animated: false)
        self.manager.startUpdatingLocation()
        self.manager.stopUpdatingLocation()
    }
    
    private struct AnnotationConstant {
        static let annotationReuseIdentifier = "pin"
        static let rightCalloutViewFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKAnnotationLocation {
            //var view = mapView.dequeueReusableAnnotationViewWithIdentifier(AnnotationConstant.annotationReuseIdentifier)
            
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationConstant.annotationReuseIdentifier)
            
            view.draggable = false
            view.canShowCallout = true
            view.animatesDrop = false
            
            let rightCalloutButton = UIButton(type: .InfoDark) as UIButton
            rightCalloutButton.frame = AnnotationConstant.rightCalloutViewFrame
            view.rightCalloutAccessoryView = rightCalloutButton
            
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("callout view pressed")
        
        let annotationViewTitle = view.annotation?.title
        let annotationSubtitle = view.annotation?.subtitle
        let annotationLat = view.annotation?.coordinate.latitude
        let annotationLong = view.annotation?.coordinate.longitude
        
        self.location = annotationViewTitle!
        self.address = annotationSubtitle!
        self.annotationLat = String(annotationLat)
        self.annotationLong = String(annotationLong)
        

        self.performSegueWithIdentifier("annotationDetailSegue", sender: view)
    


    }

    
    func getMapAnnotations(dataArray: [String]) -> [MKAnnotationLocation] {
        
        var annotations = [MKAnnotationLocation]()
        var longArray = [String]()
        var latArray = [String]()
        var locationNameArray = [String]()
        var subtitleArray = [String]()

        for element in dataArray {
            var long = String()
            var lat = String()
            var locationName = String()
            var subtitle = String()
            
            if element.containsString("SC_site: ") {
                locationName = element
                locationName.removeAtIndex(locationName.startIndex.advancedBy(0))
                locationName.removeAtIndex(locationName.startIndex.advancedBy(0))
                locationName.removeAtIndex(locationName.startIndex.advancedBy(0))
                locationName.removeAtIndex(locationName.startIndex.advancedBy(0))
                locationName.removeAtIndex(locationName.startIndex.advancedBy(0))
                locationName.removeAtIndex(locationName.startIndex.advancedBy(0))
                locationName.removeAtIndex(locationName.startIndex.advancedBy(0))
                locationName.removeAtIndex(locationName.startIndex.advancedBy(0))
                locationName.removeAtIndex(locationName.startIndex.advancedBy(0))
                locationNameArray.append(locationName)
            }
            if element.containsString("SC_address: ") {
                subtitle = element
                subtitle.removeAtIndex(subtitle.startIndex.advancedBy(0))
                subtitle.removeAtIndex(subtitle.startIndex.advancedBy(0))
                subtitle.removeAtIndex(subtitle.startIndex.advancedBy(0))
                subtitle.removeAtIndex(subtitle.startIndex.advancedBy(0))
                subtitle.removeAtIndex(subtitle.startIndex.advancedBy(0))
                subtitle.removeAtIndex(subtitle.startIndex.advancedBy(0))
                subtitle.removeAtIndex(subtitle.startIndex.advancedBy(0))
                subtitle.removeAtIndex(subtitle.startIndex.advancedBy(0))
                subtitle.removeAtIndex(subtitle.startIndex.advancedBy(0))
                subtitle.removeAtIndex(subtitle.startIndex.advancedBy(0))
                subtitle.removeAtIndex(subtitle.startIndex.advancedBy(0))
                subtitle.removeAtIndex(subtitle.startIndex.advancedBy(0))
                subtitleArray.append(subtitle)
            }
            if element.containsString("SC_lat: ") {
                lat = element
                lat.removeAtIndex(lat.startIndex.advancedBy(0))
                lat.removeAtIndex(lat.startIndex.advancedBy(0))
                lat.removeAtIndex(lat.startIndex.advancedBy(0))
                lat.removeAtIndex(lat.startIndex.advancedBy(0))
                lat.removeAtIndex(lat.startIndex.advancedBy(0))
                lat.removeAtIndex(lat.startIndex.advancedBy(0))
                lat.removeAtIndex(lat.startIndex.advancedBy(0))
                lat.removeAtIndex(lat.startIndex.advancedBy(0))
                latArray.append(lat)
            }
            if element.containsString("SC_long: ") {
                long = element
                long.removeAtIndex(long.startIndex.advancedBy(0))
                long.removeAtIndex(long.startIndex.advancedBy(0))
                long.removeAtIndex(long.startIndex.advancedBy(0))
                long.removeAtIndex(long.startIndex.advancedBy(0))
                long.removeAtIndex(long.startIndex.advancedBy(0))
                long.removeAtIndex(long.startIndex.advancedBy(0))
                long.removeAtIndex(long.startIndex.advancedBy(0))
                long.removeAtIndex(long.startIndex.advancedBy(0))
                long.removeAtIndex(long.startIndex.advancedBy(0))
                longArray.append(long)
            }
        }
        
        var currentElement_annotation = 0
        let locationArrayCount = longArray.count
        while currentElement_annotation < locationArrayCount {
            
            let annotation = MKAnnotationLocation(title: locationNameArray[currentElement_annotation + 2], subtitle: subtitleArray[currentElement_annotation + 1], coordinate: CLLocationCoordinate2D(latitude: Double(latArray[currentElement_annotation])!, longitude: Double(longArray[currentElement_annotation])!))
            annotations.append(annotation)
            currentElement_annotation += 1
        }

        return annotations
    }
    
    /*
    func barButtonAction(sender: UIBarButtonItem) {
        let firebase = Firebase(url: "https://acapps.firebaseio.com")
        firebase.unauth()
        presentViewControllerUsingNavigationControllerNoReturn("InitialView", animated: true, CompletionHandler: nil)
        
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "annotationDetailSegue"){
            let destinationVC : AnnotationDetailViewController = segue.destinationViewController as! AnnotationDetailViewController
            destinationVC.viewTitle = (sender as! MKAnnotationView).annotation!.title!!
            destinationVC.viewSubtitle = (sender as! MKAnnotationView).annotation!.subtitle!!
            destinationVC.annotationLat = String((sender as! MKAnnotationView).annotation!.coordinate.latitude)
            destinationVC.annotationLong = String((sender as! MKAnnotationView).annotation!.coordinate.longitude)
        }
    }
    
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




