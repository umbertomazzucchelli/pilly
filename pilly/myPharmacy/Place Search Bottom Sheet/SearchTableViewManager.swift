//
//  SearchTableViewManager.swift
// Repurposed from: App14  created by Sakib Miazi on 6/14/23.
// pilly
//

import Foundation
import UIKit
import CoreLocation
import MapKit

// Extension to MKPlacemark to create formatted address string
extension MKPlacemark {
    var formattedAddress: String? {
        var components: [String] = []
        
        // Add street address
        if let number = subThoroughfare {
            components.append(number)
        }
        if let street = thoroughfare {
            components.append(street)
        }
        
        // Add city
        if let city = locality {
            components.append(city)
        }
        
        // Add state/province
        if let state = administrativeArea {
            components.append(state)
        }
        
        // Add postal code
        if let postalCode = postalCode {
            components.append(postalCode)
        }
        
        // Return nil if no components are available
        guard !components.isEmpty else { return nil }
        
        // Join all components with commas
        return components.joined(separator: ", ")
    }
}

// Updated SearchViewController TableView extension
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.searchTableViewID, for: indexPath) as! SearchTableViewCell
        let mapItem = mapItems[indexPath.row]
        
        // Set the name/title
        cell.labelTitle.text = mapItem.name ?? "Unknown Location"
        
        // Create address and distance string
        var addressComponents: [String] = []
        
        // Add address if available
        if let address = mapItem.placemark.formattedAddress {
            addressComponents.append(address)
        }
        
        // Add distance if available
        if let userLocation = delegateToMapView.locationManager.location {
            let distance = calculateDistance(from: userLocation, to: mapItem.placemark.coordinate)
            addressComponents.append("Distance: \(distance)")
        }
        
        // Join all components with newlines if there are any, otherwise show "No address available"
        cell.labelAddress.text = addressComponents.isEmpty ? "No address available" : addressComponents.joined(separator: "\n")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegateToMapView.showSelectedPlace(placeItem: mapItems[indexPath.row])
        self.dismiss(animated: true)
    }
    
    private func calculateDistance(from userLocation: CLLocation, to coordinate: CLLocationCoordinate2D) -> String {
        let destinationLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distance = userLocation.distance(from: destinationLocation)
        
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            return String(format: "%.1f km", distance/1000)
        }
    }
}
