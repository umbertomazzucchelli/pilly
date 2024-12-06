//
//  LoadPlaces.swift
// Repurposed from: App14  created by Sakib Miazi on 6/14/23.
// pilly


import Foundation
import CoreLocation
import MapKit

extension PharmacyViewController{
    func loadPlacesAround(query: String){
        //MARK: initializing the notification center...
        let notificationCenter = NotificationCenter.default
        
        var mapItems = [MKMapItem]()
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query


        searchRequest.region = mapView.mapView.region


        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                return
            }
            mapItems = response.mapItems
            
            for item in response.mapItems {
                if let name = item.name,
                    let location = item.placemark.location {
                    print("\(name), \(location)")
                }
            }
            
            //MARK: posting the search results...
            notificationCenter.post(name: .placesFromMap, object: mapItems)
        }
    }
}
