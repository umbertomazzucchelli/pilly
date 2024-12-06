//
//  PharmacyViewController.swift
//  My_Profile
//
//  Created by MAD4 on 11/25/24.
//

import UIKit
import MapKit
import CoreLocation


class PharmacyViewController: UIViewController, UISearchBarDelegate{
    
    let mapView = MapView()
    
    let locationManager = CLLocationManager()
    
    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pharmacy"
        navigationController?.navigationBar.prefersLargeTitles = true
        requestLocationPermission()
        //MARK: add action for current location button tap...
        mapView.buttonCurrentLocation.addTarget(self, action: #selector(onButtonCurrentLocationTapped), for: .touchUpInside)
        
        //MARK: add action for bottom search button tap...
        mapView.buttonSearch.addTarget(self, action: #selector(onButtonSearchTapped), for: .touchUpInside)
        
        //MARK: setting up location manager...

        
        //MARK: center the map view to current location when the app loads...
        onButtonCurrentLocationTapped()
        
        
        //MARK: Annotating Northeastern University...
        let northeastern = Place(
            title: "Northeastern University",
            coordinate: CLLocationCoordinate2D(latitude: 42.339918, longitude: -71.089797),
            info: "LVX VERITAS VIRTVS"
        )
        
        mapView.mapView.addAnnotation(northeastern)
        mapView.mapView.delegate = self
    }
    func requestLocationPermission() {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.requestWhenInUseAuthorization() // Request permission for location
                locationManager.startUpdatingLocation() // Start updating the location
            } else {
                print("Location services are not enabled.")
            }
        }
    
    @objc func onButtonCurrentLocationTapped(){
        if let uwLocation = locationManager.location{
            mapView.mapView.centerToLocation(location: uwLocation)
        }
        
    }
    
    @objc func onButtonSearchTapped(){
        
        //MARK: Setting up bottom search sheet...
        let searchViewController  = SearchViewController()
        searchViewController.delegateToMapView = self
        
        let navForSearch = UINavigationController(rootViewController: searchViewController)
        navForSearch.modalPresentationStyle = .pageSheet
        
        if let searchBottomSheet = navForSearch.sheetPresentationController{
            searchBottomSheet.detents = [.medium(), .large()]
            searchBottomSheet.prefersGrabberVisible = true
        }
        
        present(navForSearch, animated: true)
    }
    
    
    //MARK: show selected place on map...
    func showSelectedPlace(placeItem: MKMapItem){
        let coordinate = placeItem.placemark.coordinate
        mapView.mapView.centerToLocation(
            location: CLLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        )
        let place = Place(
            title: placeItem.name!,
            coordinate: coordinate,
            info: placeItem.description
        )
        mapView.mapView.addAnnotation(place)
    }

}

