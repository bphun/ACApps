//
//  locations.swift
//  ACApps
//
//  Created by Brandon Phan on 4/27/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import MapKit

class MKAnnotationLocation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude:Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

}