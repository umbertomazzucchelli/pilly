//
//  MainScreenView.swift
//  pilly
//
//  Created by Belen Tesfaye on 11/24/24.
//

import UIKit

class MainScreenView: UIView {
    var pillyLogo: UIImageView!
//    var signInButton: UIButton!
    var addAccountButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupLogo()
//        setupSignIn()
//        setupAddAccount()
        initConstraints()
    }
    
    func setupLogo() {
        pillyLogo = UIImageView()
        pillyLogo.image = UIImage(named: "pillyIcon")
        pillyLogo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pillyLogo)
    }
    
//    func setupSignIn() {
//        signInButton = UIButton(type: .system)
//        signInButton.setTitle("Sign in/Create an Account", for: .normal)
//        signInButton.backgroundColor = UIColor(red: 255/255, green: 116/255, blue: 108/255, alpha: 1) // #FF746C
//        signInButton.tintColor = .white // Text color for contrast
//        signInButton.layer.cornerRadius = 27.5
//        signInButton.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(signInButton)
//    }

    
//    func setupAddAccount() {
//        addAccountButton = UIButton(type: .system)
//        addAccountButton.setTitle("Create an Account", for: .normal)
//        addAccountButton.backgroundColor = UIColor(red: 179/255, green: 235/255, blue: 242/255, alpha: 1) // #B3EBF2
//        addAccountButton.tintColor = .white // Text color for visibility
//        addAccountButton.layer.cornerRadius = 27.5
//        addAccountButton.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(addAccountButton)
//    }

    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Center the logo
            pillyLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pillyLogo.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            pillyLogo.widthAnchor.constraint(equalToConstant: 218), // Adjust size based on Figma
            pillyLogo.heightAnchor.constraint(equalToConstant: 203),
            
//            // Center the sign-in button
//            signInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            signInButton.topAnchor.constraint(equalTo: pillyLogo.bottomAnchor, constant: 50),
//            signInButton.widthAnchor.constraint(equalToConstant: 286),
//            signInButton.heightAnchor.constraint(equalToConstant: 55),
            
//            // Center the add account button
//            addAccountButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            addAccountButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
//            addAccountButton.widthAnchor.constraint(equalToConstant: 286),
//            addAccountButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
