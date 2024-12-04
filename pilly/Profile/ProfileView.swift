//
//  ProfileView.swift
//  My_Profile
//
//  Created by MAD4 on 11/18/24.
//

import UIKit

class ProfileView: UIView {
    
    var userInfoButton:UIButton!
    var label: UILabel!
    var personalInfoButton:UIButton!
    var myPharmacyButton:UIButton!
    var settingsButton:UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupuserInfoButton()
        setuplabel()
        setuppersonalInfoButton()
        setupmyPharmacyButton()
        setupsettingsButton()
        initConstraints()
    }
    
    func setupuserInfoButton() {
        userInfoButton = UIButton(type: .system)
        userInfoButton.setImage(UIImage(systemName: "person") , for: .normal)
        //userInfoButton.sizeThatFits(.init(width: 128, height: 128))
        
//        userInfoButton.systemLayoutSizeFitting(.init(width: 32, height: 32), withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultHigh)
        userInfoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userInfoButton)
    }
    func setuplabel() {
        label = UILabel()
        label.text = "User Info"
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
    }
    func setuppersonalInfoButton() {
        personalInfoButton = UIButton(type: .system)
        personalInfoButton.setTitle("Personal Info", for: .normal)
        personalInfoButton.titleLabel?.font = .boldSystemFont(ofSize: 28)
        personalInfoButton.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        personalInfoButton.tintColor = .white
        personalInfoButton.backgroundColor = .cyan
        personalInfoButton.layer.cornerRadius = 5
        personalInfoButton.layer.shadowOffset = .zero
        
        personalInfoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(personalInfoButton)
    }
    func setupmyPharmacyButton() {
        myPharmacyButton = UIButton(type: .system)
        myPharmacyButton.setTitle("My Pharmacy", for: .normal)
        myPharmacyButton.titleLabel?.font = .boldSystemFont(ofSize: 28)
        myPharmacyButton.setImage(UIImage(systemName: "location.magnifyingglass"), for: .normal)
        myPharmacyButton.backgroundColor = .red
        myPharmacyButton.tintColor = .white
        myPharmacyButton.layer.cornerRadius = 5
        myPharmacyButton.layer.shadowOffset = .zero
        myPharmacyButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(myPharmacyButton)
    }
    func setupsettingsButton() {
        settingsButton = UIButton(type: .system)
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.titleLabel?.font = .boldSystemFont(ofSize: 28)
        settingsButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        settingsButton.tintColor = .white
        settingsButton.backgroundColor = .cyan
        settingsButton.layer.cornerRadius = 5 // to make the background roundish
        settingsButton.layer.shadowOffset = .zero
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(settingsButton)
    }
    func initConstraints() {
        NSLayoutConstraint.activate([
            userInfoButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 128),
            userInfoButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            label.topAnchor.constraint(equalTo: userInfoButton.bottomAnchor, constant: 32),
            label.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            personalInfoButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 64),
            personalInfoButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            myPharmacyButton.topAnchor.constraint(equalTo: personalInfoButton.bottomAnchor, constant: 32),
            myPharmacyButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            settingsButton.topAnchor.constraint(equalTo: myPharmacyButton.bottomAnchor, constant: 32),
            settingsButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
