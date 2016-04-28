//
//  MapView.swift
//  ACApps
//
//  Created by Brandon Phan on 4/25/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import MapKit

class MapView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    let xmlParser = XMLParser()
    var hospitalDataArray = [String]()
    var schoolDataArray = [String]()
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_main_queue()) {
            let navBarImage = UIImage(named: "CarePackage-Header")
            self.navigationItem.titleView = UIImageView(image: navBarImage)
            self.navigationBar.hidesBackButton = true
            
            //let rightBarButtonItemImage = UIImage(named: "Extra")?.imageWithRenderingMode(.AlwaysTemplate)
            //let barButtonItem = UIBarButtonItem(image: rightBarButtonItemImage, style: .Plain, target: self, action: <#T##Selector#>)
            //self.navigationBar.leftBarButtonItem = barButtonItem
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) { () -> Void in
            
            self.xmlParser.parse({ (success) in
                if success == true {
                    self.hospitalDataArray = self.xmlParser.hospitalDataArray
                    self.schoolDataArray = self.xmlParser.schoolDataArray
                    print("Successful parse")
                    
                    let dataArray = [self.schoolDataArray, self.hospitalDataArray]

                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
                        for array in dataArray {
                            let annotations = self.getMapAnnotations(array)
                            dispatch_async(dispatch_get_main_queue()) {
                                self.mapView.addAnnotations(annotations)
                                print("Added annotation")
                            }
                        }
                    }

                }
            })
            self.setupMapView()
        }
    }
    
    func setupMapView() {
    
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.requestAlwaysAuthorization()
        self.manager.startUpdatingLocation()
        
        dispatch_sync(dispatch_get_main_queue()) {
            self.mapView.showsUserLocation = true
            self.mapView.userLocationVisible
            self.mapView.scrollEnabled = true
            self.mapView.zoomEnabled = true
            self.mapView.userInteractionEnabled = true
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.mapView.setRegion(region, animated: true)
    
        self.mapView.setUserTrackingMode(.Follow, animated: false)
        self.manager.startUpdatingLocation()
        self.manager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: ", error.localizedDescription)
    }
    

    func getMapAnnotations(dataArray: [String]) -> [MKAnnotationLocation] {
        var annotations = [MKAnnotationLocation]()
        
        for item in dataArray {
            print(item)
            let lat = item[0...6] as! Double
            let long = item[0...5] as! Double
            let annotation = MKAnnotationLocation(latitude: lat, longitude: long)
            annotations.append(annotation)
            print(annotation)
            print("Added annotation to annotation array")
        }
        
        return annotations
    }

}

