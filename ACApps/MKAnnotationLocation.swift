//
//  locations.swift
//  ACApps
//
//  Created by Brandon Phan on 4/27/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import MapKit

class MKAnnotationLocation: NSObject, MKAnnotation {
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }


}

/*
 
 init(latitude: Double, longitude: Double, title: String, subtitle: String) {
 self.latitude = latitude
 self.longitude = longitude
 self.title = title
 self.subtitle = subtitle
 
 super.init()
 }
 
 var coordinate: CLLocationCoordinate2D {
 return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
 }
 */