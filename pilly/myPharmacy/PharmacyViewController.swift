//
//  PharmacyViewController.swift
//  My_Profile
//
//  Created by MAD4 on 11/25/24.
//

import UIKit
import MapKit

class PharmacyViewController: UIViewController, UISearchBarDelegate{
    
    let pharmacyView = PharmacyView()
    let locationManager = CLLocationManager()
    
    override func loadView() {
        view = pharmacyView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pharmacy"
        pharmacyView.searchBar.delegate = self
        pharmacyView.buttonCurrentLocation.addTarget(self, action: #selector(onButtonCurrentLocationTapped), for: .touchUpInside)
       
        
        setupLocationManager()
        

        // Do any additional setup after loading the view.
        
        onButtonCurrentLocationTapped()
    }
    
    @objc func onButtonCurrentLocationTapped() {
        if let uwLocation = locationManager.location {
            pharmacyView.mapView.centerToLocation(location: uwLocation)  // Center map on user's location
        } else {
            print("Location is not available yet.")  // Debug message if location is unavailable
        }
    }
    
    func searchForNearbyPharmacies(query: String, location: CLLocation) {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query  // "pharmacy"
            request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)  // Search within 5km
            
            let search = MKLocalSearch(request: request)
            
            search.start { (response, error) in
                if let error = error {
                    print("Error searching for pharmacies: \(error.localizedDescription)")
                    return
                }
                
                guard let response = response else {
                    print("No results found.")
                    return
                }
                
                // Remove previous annotations
                self.pharmacyView.mapView.removeAnnotations(self.pharmacyView.mapView.annotations)
                
                // Add new annotations for pharmacies
                for mapItem in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.title = mapItem.name
                    annotation.subtitle = mapItem.placemark.title
                    annotation.coordinate = mapItem.placemark.coordinate
                    self.pharmacyView.mapView.addAnnotation(annotation)
                }
            }
        }
        
        // UISearchBarDelegate method to handle search query
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if let query = searchBar.text, let location = locationManager.location {
                searchForNearbyPharmacies(query: query, location: location)  // Perform search
            }
            searchBar.resignFirstResponder()  // Dismiss keyboard
        }


   

}

extension MKMapView {
    func centerToLocation(location : CLLocation , radius : CLLocationDistance = 1000 ) // radius is 1 km
    {
        let coordinateRegion = MKCoordinateRegion(
                    center: location.coordinate,
                    latitudinalMeters: radius,
                    longitudinalMeters: radius
                )
                setRegion(coordinateRegion, animated: true)
    }
}

