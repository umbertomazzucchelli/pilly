//
//  Location_Manager.swift
//  My_Profile
//
//  Created by MAD4 on 11/25/24.
//

import Foundation
import CoreLocation

extension PharmacyViewController : CLLocationManagerDelegate {
    func setupLocationManager() {
            // Set the location manager's delegate and desired accuracy
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // Request location access if necessary
            locationManager.requestWhenInUseAuthorization()
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()  // Start if authorized
            case .denied, .restricted:
                print("Location access denied or restricted.")
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()  // Request permission if not determined
            @unknown default:
                print("Unknown authorization status.")
            }
        }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                pharmacyView.buttonLoading.isHidden = true
                print("Location updated: \(location)")
            }
        }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to update location: \(error.localizedDescription)")
    }

}
