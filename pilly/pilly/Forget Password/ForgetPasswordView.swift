//
//  ForgetPasswordView.swift
//  pilly
//
//  Created by Belen Tesfaye on 10/24/24.
//

import UIKit


class ForgetPasswordView: UIView {
    
    var appIconImageView: UIImageView!
    var emailTextField: UITextField!
    var submitButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupAppIconImageView()
        setupEmailTextField()
        setupSubmitButton()
        initConstraints()
    }
    
    func setupSubmitButton() {
        submitButton = UIButton(type: .system)
        submitButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(submitButton)
    }

    func setupEmailTextField() {
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailTextField)
    }

    func setupAppIconImageView() {
        appIconImageView = UIImageView()
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false
        appIconImageView.image = UIImage(named: "pillyIcon")
        addSubview(appIconImageView)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            appIconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            appIconImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
            appIconImageView.widthAnchor.constraint(equalToConstant: 200),
            appIconImageView.heightAnchor.constraint(equalToConstant: 200),
            
            emailTextField.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            submitButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 32)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
