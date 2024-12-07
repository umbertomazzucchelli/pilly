//
//  ProfileView.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 12/7/24.
//

import UIKit
import Firebase

class ProfileView: UIView {
    
    var userInfoButton: UIButton!
    var nameLabel: UILabel!
    var personalInfoButton: UIButton!
    var myPharmacyButton: UIButton!
    var settingsButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUserInfoButton()
        setupNameLabel()
        setupPersonalInfoButton()
        setupMyPharmacyButton()
        setupSettingsButton()
        initConstraints()
        loadUserData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserInfoButton() {
        userInfoButton = UIButton(type: .system)
        userInfoButton.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        userInfoButton.tintColor = .systemBlue
        userInfoButton.contentVerticalAlignment = .fill
        userInfoButton.contentHorizontalAlignment = .fill
        userInfoButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(userInfoButton)
    }
    
    private func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
    }
    
    func setupPersonalInfoButton() {
        personalInfoButton = UIButton(type: .system)
        personalInfoButton.setTitle("Personal Info", for: .normal)
        personalInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        personalInfoButton.setImage(UIImage(systemName: "person.fill"), for: .normal)
        personalInfoButton.backgroundColor = UIColor(red: 0.702, green: 0.922, blue: 0.949, alpha: 1)
        personalInfoButton.tintColor = .white
        personalInfoButton.layer.cornerRadius = 10
        personalInfoButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(personalInfoButton)
    }
    
    func setupMyPharmacyButton() {
        myPharmacyButton = UIButton(type: .system)
        myPharmacyButton.setTitle("Set My Pharmacy", for: .normal)
        myPharmacyButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        myPharmacyButton.setImage(UIImage(systemName: "cross.fill"), for: .normal)
        myPharmacyButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.3)
        myPharmacyButton.tintColor = .white
        myPharmacyButton.layer.cornerRadius = 10
        myPharmacyButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(myPharmacyButton)
    }
    
    func setupSettingsButton() {
        settingsButton = UIButton(type: .system)
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.backgroundColor = UIColor(red: 0.702, green: 0.922, blue: 0.949, alpha: 1)
        settingsButton.tintColor = .white
        settingsButton.layer.cornerRadius = 10
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(settingsButton)
    }
    
    private func initConstraints() {
        let buttonWidth: CGFloat = UIScreen.main.bounds.width - 40 // 20 points padding on each side
        let buttonHeight: CGFloat = 50
        
        NSLayoutConstraint.activate([
            // User Info Button (Profile Picture)
            userInfoButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            userInfoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            userInfoButton.widthAnchor.constraint(equalToConstant: 100),
            userInfoButton.heightAnchor.constraint(equalToConstant: 100),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: userInfoButton.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Personal Info Button
            personalInfoButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 40),
            personalInfoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            personalInfoButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            personalInfoButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            // My Pharmacy Button
            myPharmacyButton.topAnchor.constraint(equalTo: personalInfoButton.bottomAnchor, constant: 20),
            myPharmacyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            myPharmacyButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            myPharmacyButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            // Settings Button
            settingsButton.topAnchor.constraint(equalTo: myPharmacyButton.bottomAnchor, constant: 20),
            settingsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            settingsButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
    private func loadUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            guard let self = self,
                  let data = document?.data(),
                  error == nil else { return }
            
            DispatchQueue.main.async {
                if let firstName = data["firstName"] as? String,
                   let lastName = data["lastName"] as? String {
                    self.nameLabel.text = "\(firstName) \(lastName)"
                }
            }
        }
    }
    
    func updateFavoritePharmacy() {
        PharmacyManager.shared.getFavoritePharmacy { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pharmacy):
                    if let pharmacy = pharmacy {
                        var config = UIButton.Configuration.filled()
                        config.title = "My Pharmacy: \(pharmacy.name)"
                        
                        // Only show address if it's not empty
                        if !pharmacy.address.isEmpty && pharmacy.address != "No address available" {
                            config.subtitle = pharmacy.address
                        }
                        
                        config.image = UIImage(systemName: "location.magnifyingglass")
                        config.imagePlacement = .leading
                        config.imagePadding = 8
                        config.titleAlignment = .leading
                        config.background.backgroundColor = UIColor.systemPink.withAlphaComponent(0.3)
                        
                        self?.myPharmacyButton.configuration = config
                    } else {
                        // No favorite pharmacy set
                        self?.myPharmacyButton.setTitle("Set My Pharmacy", for: .normal)
                    }
                case .failure(let error):
                    print("Error fetching favorite pharmacy: \(error)")
                    self?.myPharmacyButton.setTitle("Set My Pharmacy", for: .normal)
                }
            }
        }
    }
}
