//
//  PersonalInfoViewController.swift
//  My_Profile
//
//  Created by MAD4 on 11/25/24.
//

import UIKit

class PersonalInfoViewController: UIViewController {
    
    var personalInfoView: PersonalInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the PersonalInfoView
        personalInfoView = PersonalInfoView(frame: view.bounds)
        view.addSubview(personalInfoView)
        
        // Load user data for the first time when the view is loaded
        personalInfoView.loadUserData()
    }
    
    // This method is called every time the view is about to appear on the screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh the user data when coming back to this screen
        personalInfoView.loadUserData()
    }
}
