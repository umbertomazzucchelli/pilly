//
//  PharmacyView.swift
//  My_Profile
//
//  Created by MAD4 on 11/25/24.
//

import UIKit
import MapKit

class PharmacyView: UIView {
    
    var mapView:MKMapView!
    var buttonLoading:UIButton!
    var buttonCurrentLocation:UIButton!
    var searchBar: UISearchBar!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupMapView()
        setupButtonLoading()
        setupButtonCurrentLocation()
        setupSearchBar()
        initConstraints()
    }
    func setupSearchBar() {
            searchBar = UISearchBar()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchBar.placeholder = "Search for pharmacies"
            self.addSubview(searchBar)
        }
    func setupMapView(){
            mapView = MKMapView()
            mapView.translatesAutoresizingMaskIntoConstraints = false
            mapView.layer.cornerRadius = 10
            self.addSubview(mapView)
        }
        
        func setupButtonLoading(){
            buttonLoading = UIButton(type: .system)
            buttonLoading.setTitle(" Fetching Location...  ", for: .normal)
            buttonLoading.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            buttonLoading.setImage(UIImage(systemName: "circle.dotted"), for: .normal)
            buttonLoading.layer.backgroundColor = UIColor.black.cgColor
            buttonLoading.tintColor = .white
            buttonLoading.layer.cornerRadius = 10
            
            buttonLoading.layer.shadowOffset = .zero
            buttonLoading.layer.shadowRadius = 4
            buttonLoading.layer.shadowOpacity = 0.7
            
            buttonLoading.translatesAutoresizingMaskIntoConstraints = false
            
            buttonLoading.isEnabled = false
            self.addSubview(buttonLoading)
        }
        
        func setupButtonCurrentLocation(){
            buttonCurrentLocation = UIButton(type: .system)
            buttonCurrentLocation.setImage(UIImage(systemName: "location.circle"), for: .normal)
            buttonCurrentLocation.layer.backgroundColor = UIColor.lightGray.cgColor
            buttonCurrentLocation.tintColor = .blue
            buttonCurrentLocation.layer.cornerRadius = 10
            
            buttonCurrentLocation.layer.shadowOffset = .zero
            buttonCurrentLocation.layer.shadowRadius = 4
            buttonCurrentLocation.layer.shadowOpacity = 0.7
            
            buttonCurrentLocation.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(buttonCurrentLocation)
        }
        
        func initConstraints(){
            NSLayoutConstraint.activate([
                mapView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                mapView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
                mapView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
                mapView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.95),
                
                buttonLoading.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
                buttonLoading.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
                buttonLoading.widthAnchor.constraint(equalToConstant: 240),
                buttonLoading.heightAnchor.constraint(equalToConstant: 40),
                
                buttonCurrentLocation.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
                buttonCurrentLocation.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -8),
                buttonCurrentLocation.heightAnchor.constraint(equalToConstant: 36),
                buttonCurrentLocation.widthAnchor.constraint(equalToConstant: 36),
                searchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
                          searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                          searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
