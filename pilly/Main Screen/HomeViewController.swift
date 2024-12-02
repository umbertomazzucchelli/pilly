//
//  HomeViewController.swift
//  pilly
//
//  Created by Belen Tesfaye on 12/1/24.
//

import UIKit

class HomeViewController: UIViewController {

    var medListView: MedListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "My Medications"
        
        setupMedListView()
    }
    
    func setupMedListView() {
        // Initialize MedListView
        medListView = MedListView()
        medListView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(medListView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            medListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            medListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            medListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            medListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Load sample data
        medListView.loadData()
    }
}
