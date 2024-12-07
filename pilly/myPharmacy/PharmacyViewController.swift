//
//  PharmacyViewController.swift
//  My_Profile
//
//  Created by MAD4 on 11/25/24.
//

import UIKit
import MapKit
import CoreLocation


class PharmacyViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    let mapView = MapView()
    let locationManager = CLLocationManager()
    
    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pharmacy"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Setup location manager and map
        setupLocationServices()
        
        // Add action for current location button tap
        mapView.buttonCurrentLocation.addTarget(self, action: #selector(onButtonCurrentLocationTapped), for: .touchUpInside)
        
        // Add action for bottom search button tap
        mapView.buttonSearch.addTarget(self, action: #selector(onButtonSearchTapped), for: .touchUpInside)
        
        mapView.mapView.delegate = self
    }
    
    private func setupLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Enable user location display
        mapView.mapView.showsUserLocation = true
        mapView.mapView.userTrackingMode = .follow
        
        // Request permission
        requestLocationPermission()
    }
    
    func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showLocationPermissionAlert()
        @unknown default:
            break
        }
    }

    @objc func onButtonCurrentLocationTapped() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            if let location = locationManager.location {
                mapView.mapView.setCenter(location.coordinate, animated: true)
                mapView.mapView.userTrackingMode = .follow
                mapView.buttonLoading.isHidden = true
            }
        case .denied, .restricted:
            showLocationPermissionAlert()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }

    @objc func onButtonSearchTapped() {
        let searchViewController = SearchViewController()
        searchViewController.delegateToMapView = self
        
        let navForSearch = UINavigationController(rootViewController: searchViewController)
        navForSearch.modalPresentationStyle = .pageSheet
        
        if let searchBottomSheet = navForSearch.sheetPresentationController {
            searchBottomSheet.detents = [.medium(), .large()]
            searchBottomSheet.prefersGrabberVisible = true
        }
        
        present(navForSearch, animated: true)
    }
    
    func showLocationPermissionAlert() {
        let alert = UIAlertController(
            title: "Location Access Required",
            message: "Please enable location access in Settings to find nearby pharmacies.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        mapView.buttonLoading.isHidden = true
        mapView.buttonSearch.isHidden = false
        
        // Center map on first location update
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.mapView.setRegion(region, animated: true)
        
        // Stop updating location after initial set
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        mapView.buttonLoading.isHidden = true
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            mapView.mapView.showsUserLocation = true
        case .denied, .restricted:
            showLocationPermissionAlert()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    // MARK: - Place Selection
    func showSelectedPlace(placeItem: MKMapItem) {
        let coordinate = placeItem.placemark.coordinate
        mapView.mapView.centerToLocation(
            location: CLLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        )
        
        // Create a more detailed place annotation
        var detailInfo = ""
        if let address = placeItem.placemark.formattedAddress {
            detailInfo += address
        }
        
        if let userLocation = locationManager.location {
            let distance = calculateDistance(from: userLocation, to: coordinate)
            detailInfo += "\nDistance: \(distance)"
        }
        
        let place = Place(
            title: placeItem.name ?? "Unknown",
            coordinate: coordinate,
            info: detailInfo
        )
        
        // Remove existing annotations and add the new one
        mapView.mapView.removeAnnotations(mapView.mapView.annotations)
        mapView.mapView.addAnnotation(place)
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
