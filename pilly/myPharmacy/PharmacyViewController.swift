//
//  PharmacyViewController.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 12/7/24.
//

import UIKit
import MapKit
import CoreLocation

class PharmacyViewController: UIViewController {
    
    let mapView = MapView()
    let locationManager = CLLocationManager()
    
    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pharmacy"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupLocationServices()
        setupButtonActions()
        mapView.mapView.delegate = self
        loadFavoritePharmacy()
    }
    
    private func setupLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.mapView.showsUserLocation = true
        mapView.mapView.userTrackingMode = .follow
        
        requestLocationPermission()
    }
    
    private func setupButtonActions() {
        mapView.buttonCurrentLocation.addTarget(self, action: #selector(onButtonCurrentLocationTapped), for: .touchUpInside)
        mapView.buttonSearch.addTarget(self, action: #selector(onButtonSearchTapped), for: .touchUpInside)
    }
    
    private func loadFavoritePharmacy() {
        PharmacyManager.shared.getFavoritePharmacy { [weak self] result in
            switch result {
            case .success(let pharmacy):
                if let pharmacy = pharmacy {
                    DispatchQueue.main.async {
                        let coordinate = CLLocationCoordinate2D(latitude: pharmacy.latitude, longitude: pharmacy.longitude)
                        let place = Place(
                            title: pharmacy.name,
                            coordinate: coordinate,
                            info: pharmacy.address
                        )
                        self?.mapView.mapView.addAnnotation(place)
                        self?.mapView.mapView.setCenter(coordinate, animated: true)
                    }
                }
            case .failure(let error):
                print("Error loading favorite pharmacy: \(error)")
            }
        }
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
    
    func showSelectedPlace(placeItem: MKMapItem) {
        let coordinate = placeItem.placemark.coordinate
        mapView.mapView.centerToLocation(
            location: CLLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        )
        
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
        
        mapView.mapView.removeAnnotations(mapView.mapView.annotations)
        mapView.mapView.addAnnotation(place)
        
        showPharmacyOptions(for: placeItem)
    }
    
    func showPharmacyOptions(for mapItem: MKMapItem) {
        let actionSheet = UIAlertController(
            title: mapItem.name,
            message: mapItem.placemark.formattedAddress,
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(title: "Set as Favorite Pharmacy", style: .default) { [weak self] _ in
            self?.setFavoritePharmacy(mapItem)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Get Directions", style: .default) { [weak self] _ in
            self?.openDirections(to: mapItem)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(actionSheet, animated: true)
    }
    
    private func openDirections(to mapItem: MKMapItem) {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    private func setFavoritePharmacy(_ mapItem: MKMapItem) {
        PharmacyManager.shared.saveFavoritePharmacy(pharmacy: mapItem) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Post notification immediately after successful save
                    NotificationCenter.default.post(name: .favoritePharmacyUpdated, object: nil)
                    self?.showSuccessAlert()
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Success",
            message: "Favorite pharmacy has been set successfully!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: "Failed to set favorite pharmacy: \(message)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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

// MARK: - CLLocationManagerDelegate
extension PharmacyViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        mapView.buttonLoading.isHidden = true
        mapView.buttonSearch.isHidden = false
        
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.mapView.setRegion(region, animated: true)
        
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
}
