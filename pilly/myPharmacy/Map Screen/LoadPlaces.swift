//
//  LoadPlaces.swift
// Repurposed from: App14  created by Sakib Miazi on 6/14/23.
// pilly


import Foundation
import CoreLocation
import MapKit

extension PharmacyViewController {
    func loadPlacesAround(query: String) {
        // Validate input
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            // Notify user that search query is empty
            return
        }
        
        // Start loading indicator
        mapView.buttonLoading.isHidden = false
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        
        // Validate map region
        let region = mapView.mapView.region
        guard region.span.latitudeDelta > 0, region.span.longitudeDelta > 0 else {
            // Use a default region or current location if map region is invalid
            if let userLocation = locationManager.location {
                searchRequest.region = MKCoordinateRegion(
                    center: userLocation.coordinate,
                    latitudinalMeters: 5000,
                    longitudinalMeters: 5000
                )
            }
            return
        }
        
        searchRequest.region = region
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] (response, error) in
            guard let self = self else { return }
            
            // Stop loading indicator
            DispatchQueue.main.async {
                self.mapView.buttonLoading.isHidden = true
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.showSearchError(error)
                }
                return
            }
            
            guard let response = response, !response.mapItems.isEmpty else {
                DispatchQueue.main.async {
                    self.showNoResultsAlert()
                }
                return
            }
            
            // Log search results
            response.mapItems.forEach { item in
                if let name = item.name,
                   let location = item.placemark.location {
                    print("\(name), \(location)")
                }
            }
            
            // Post results to notification center
            NotificationCenter.default.post(
                name: .placesFromMap,
                object: response.mapItems
            )
        }
    }
    
    private func showSearchError(_ error: Error) {
        let alert = UIAlertController(
            title: "Search Error",
            message: "Unable to search for pharmacies: \(error.localizedDescription)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showNoResultsAlert() {
        let alert = UIAlertController(
            title: "No Results",
            message: "No pharmacies found in this area. Try expanding your search.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
