//
//  MainScreenViewController.swift
//  pilly
//
//  Created by Belen Tesfaye on 12/3/24.
//

import UIKit

class MainScreenViewController: UIViewController {

    let mainScreenView = MainScreenView()
    
    override func loadView() {
        view = mainScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the view as needed
    }
}

