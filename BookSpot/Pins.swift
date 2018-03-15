////
////  Pins.swift
////  BookSpot
////
////  Created by Claire Jakoby on 22-02-16.
////  Copyright © 2016 Clair&Sida. All rights reserved.
////

import UIKit
import MapKit

class BookAnnotation : NSObject, MKAnnotation {
    
    var currentObject : PFObject?
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var author: String?
    var subtitle: String?
    var image: PFFile?
    var gerne: String?
    
    init(object: PFObject) {
        self.currentObject = object
        let locationPoint = object.value(forKey: "location")
        let loc = CLLocationCoordinate2D(latitude: (locationPoint! as AnyObject).latitude, longitude: (locationPoint! as AnyObject).latitude)
        self.coordinate = loc
        self.title = object.value(forKey: "title") as? String
        self.subtitle = object.value(forKey: "descriptionNew") as? String

        self.author = object.value(forKey: "author") as? String
        self.gerne = object.value(forKey: "gerne") as? String
        self.image = object.value(forKey: "photo") as? PFFile
        
    }
}
