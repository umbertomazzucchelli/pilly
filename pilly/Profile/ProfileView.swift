//
//  ProfileView.swift
//  My_Profile
//
//  Created by MAD4 on 11/18/24.
//

import UIKit

class ProfileView: UIView {
    
    var userInfoButton: UIButton!
    var label: UILabel!
    var personalInfoButton: UIButton!
    var myPharmacyButton: UIButton!
    var settingsButton: UIButton!

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
        userInfoButton.setImage(UIImage(systemName: "person"), for: .normal)
        userInfoButton.titleLabel?.font = UIFont(name: "Comic Sans MS", size: 28) // Set Comic Sans font
        userInfoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userInfoButton)
    }

    func setuplabel() {
        label = UILabel()
        label.text = "User Info"
        label.font = UIFont(name: "Open Sans MS", size: 28) // Set Comic Sans font
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
    }
    
    func setuppersonalInfoButton() {
        personalInfoButton = UIButton(type: .system)
        personalInfoButton.setTitle("Personal Info", for: .normal)
        personalInfoButton.titleLabel?.font = UIFont(name: "Comic Sans MS", size: 28) // Set Comic Sans font
        personalInfoButton.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        personalInfoButton.tintColor = .white
        personalInfoButton.backgroundColor = UIColor(red: 0.702, green: 0.922, blue: 0.949, alpha: 1)
        personalInfoButton.layer.cornerRadius = 5
        personalInfoButton.layer.shadowOffset = .zero
        personalInfoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(personalInfoButton)
    }
    
    func setupmyPharmacyButton() {
        myPharmacyButton = UIButton(type: .system)
        myPharmacyButton.setTitle("My Pharmacy", for: .normal)
        myPharmacyButton.titleLabel?.font = UIFont(name: "Comic Sans MS", size: 28) // Set Comic Sans font
        myPharmacyButton.setImage(UIImage(systemName: "location.magnifyingglass"), for: .normal)
        myPharmacyButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.3)
        myPharmacyButton.tintColor = .white
        myPharmacyButton.layer.cornerRadius = 5
        myPharmacyButton.layer.shadowOffset = .zero
        myPharmacyButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(myPharmacyButton)
    }
    
    func setupsettingsButton() {
        settingsButton = UIButton(type: .system)
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.titleLabel?.font = UIFont(name: "Comic Sans MS", size: 28) // Set Comic Sans font
        settingsButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        settingsButton.tintColor = .white
        settingsButton.backgroundColor = UIColor(red: 0.702, green: 0.922, blue: 0.949, alpha: 1)
        settingsButton.layer.cornerRadius = 5
        settingsButton.layer.shadowOffset = .zero
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(settingsButton)
    }
    
    func initConstraints() {
        // Ensure all buttons are the same size by setting explicit width and height
        let buttonWidth: CGFloat = 231
        let buttonHeight: CGFloat = 55
        
        NSLayoutConstraint.activate([
            userInfoButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 128),
            userInfoButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            userInfoButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            userInfoButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            label.topAnchor.constraint(equalTo: userInfoButton.bottomAnchor, constant: 32),
            label.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            personalInfoButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 64),
            personalInfoButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            personalInfoButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            personalInfoButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            myPharmacyButton.topAnchor.constraint(equalTo: personalInfoButton.bottomAnchor, constant: 32),
            myPharmacyButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            myPharmacyButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            myPharmacyButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            settingsButton.topAnchor.constraint(equalTo: myPharmacyButton.bottomAnchor, constant: 32),
            settingsButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            settingsButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
