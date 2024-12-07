//
//  AddAccountView.swift
//  pilly
//
//  Created by Belen Tesfaye on 10/28/24.
//

import UIKit

class AddAccountView: UIView {
    // MARK: - UI Components
    private(set) lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private(set) lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First Name"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.autocapitalizationType = .words
        return textField
    }()
    
    private(set) lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last Name"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.autocapitalizationType = .words
        return textField
    }()
    
    private(set) lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private(set) lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.isSecureTextEntry = true
        textField.textContentType = nil
        return textField
    }()
    
    private(set) lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phone number"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.keyboardType = .phonePad
        return textField
    }()
    
    private(set) lazy var profileImageButton: UIButton = {
        let button = UIButton(type: .system)
        let cameraImage = UIImage(systemName: "camera.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(cameraImage, for: .normal)
        button.tintColor = .systemBlue.withAlphaComponent(0.3)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 50  // Half of the height/width for circle
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // Add subviews
        addSubview(stackView)
        addSubview(profileImageButton)
        addSubview(createAccountButton)
        
        stackView.addArrangedSubview(firstNameTextField)
        stackView.addArrangedSubview(lastNameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(phoneTextField)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            profileImageButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            profileImageButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageButton.widthAnchor.constraint(equalToConstant: 100),
            profileImageButton.heightAnchor.constraint(equalToConstant: 100),
            
            createAccountButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            createAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
    }
}
