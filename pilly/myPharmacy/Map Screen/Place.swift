//
//  Place.swift
//  App14
//
//  Created by Sakib Miazi on 6/14/23.
//

import MapKit
import UIKit

class Place: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    
    var mapItem: MKMapItem?{
        guard let location = title else{
            return nil
        }
        
        let placemark = MKPlacemark(
            coordinate: coordinate,
            addressDictionary:  [:]
        )
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}
