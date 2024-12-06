//
//  MainScreenView.swift
//  pilly
//
//  Created by Belen Tesfaye on 11/24/24.
//

import UIKit

class MainScreenView: UIView {
    var pillyLogo: UIImageView!
    var addAccountButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupLogo()
        initConstraints()
    }
    
    func setupLogo() {
        pillyLogo = UIImageView()
        pillyLogo.image = UIImage(named: "pillyIcon")
        pillyLogo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pillyLogo)
    }

    
    func initConstraints() {
        NSLayoutConstraint.activate([
            pillyLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pillyLogo.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            pillyLogo.widthAnchor.constraint(equalToConstant: 218),
            pillyLogo.heightAnchor.constraint(equalToConstant: 203),
        ])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
