//
//  AddAccountViewController.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 11/4/24.
//

import UIKit

class AddAccountViewController: UIViewController {
    
    let addView = AddAccountView()
    
    override func loadView() {
        view = addView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    private func setupNavigation() {
        title = "Add New Account"
        // This ensures the navigation bar is visible
        navigationController?.navigationBar.isHidden = false
        // This removes the "Back" text and just shows the arrow
        navigationItem.backButtonDisplayMode = .minimal
    }
}
