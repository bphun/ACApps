//
//  annotationDetailView.swift
//  ACApps
//
//  Created by Brandon Phan on 5/1/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AnnotationDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var viewTitle = String()
    var viewSubtitle = String()
    var annotationLat = String()
    var annotationLong = String()
    
    let manager = CLLocationManager()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var directionsButton: UIButton!
    
    let foodArray = [("Apples"),
                     ("Grapes"),
                     ("Bannanas"),
                     ("Oranges"),
                     ("Tangerines"),
                     ("Peachs"),
                     ("Strawberies"),
                     ("Pears"),
                     ("Carrots"),
                     ("Tomatoes"),
                     ("Lettuce"),
                     ("Spinach"),
                     ("Potatoes"),
                     ("Asparagus"),
                     ("Celery"),
                     ("Pineapple"),
                     ("Mango")
    ]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        directionsButton.setTitle("Directions to \(viewTitle)", forState: .Normal)
        
        let topSeperatorView = UIView(frame: CGRectMake(0,299,self.view.frame.width,1.0))
        topSeperatorView.layer.borderWidth = 1.0
        topSeperatorView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.addSubview(topSeperatorView)
        
        let bottomSeperatorView = UIView(frame: CGRectMake(0,330,self.view.frame.width,1.0))
        bottomSeperatorView.layer.borderWidth = 1.0
        bottomSeperatorView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.addSubview(bottomSeperatorView)
 
        let annotationCoordinate = CLLocationCoordinate2D(latitude: Double(self.annotationLat)!, longitude: Double(self.annotationLong)!)
        let annotation = MKAnnotationLocation(title: viewTitle, subtitle: viewSubtitle, coordinate: annotationCoordinate)
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: false)
        
        setupMapView()
    }
    @IBAction func addButton(sender: AnyObject) {
        
    }
    @IBAction func directionsButton(sender: AnyObject) {
        let destinationCoordinate = CLLocationCoordinate2D(latitude: Double(self.annotationLat)!, longitude: Double(self.annotationLong)!)
        let placeMark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        let destination = MKMapItem(placemark: placeMark)
        
        let openInMapsOptions = ["Driving" : MKLaunchOptionsDirectionsModeDriving]
        destination.openInMapsWithLaunchOptions(openInMapsOptions)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let(food) = foodArray[indexPath.row]
        
        cell.textLabel?.text = food
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let darkView = UIView(frame: CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height))
        
        let successAlertView = SCLAlertView()
        successAlertView.addButton("Okay") { 
            successAlertView.removeFromParentViewController()
            darkView.removeFromSuperview()
        }
        let(food) = foodArray[indexPath.row]
        self.view.addSubview(darkView)
        successAlertView.showSuccess("Success", subTitle: "\(food) will be available for you to pickup")
    }
    
    func setupMapView() {
        
        self.manager.delegate = self
        self.mapView.delegate = self
        
        dispatch_async(dispatch_get_main_queue()) {
            let annotationCoordinate = CLLocationCoordinate2D(latitude: Double(self.annotationLat)!, longitude: Double(self.annotationLong)!)
            
            self.mapView.showsUserLocation = false
            self.mapView.mapType = .SatelliteFlyover
            self.mapView.scrollEnabled = false
            self.mapView.zoomEnabled = false
            self.mapView.userInteractionEnabled = false
            self.mapView.showsScale = false
            self.mapView.showsCompass = false
            self.mapView.region = MKCoordinateRegion(center: annotationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        }
    }
    
    
    
}