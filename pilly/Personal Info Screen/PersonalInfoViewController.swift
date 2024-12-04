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
        
        // Load user data
        personalInfoView.loadUserData()
    }


}

