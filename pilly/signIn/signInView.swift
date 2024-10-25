//
//  signInView.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 10/25/24.
//

import UIKit

class signInView: UIView {
    // MARK: - UI Components
    private(set) lazy var pillImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "pill-icon")
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private(set) lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "username/email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private(set) lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private(set) lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot password?", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private(set) lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(backButton)
        addSubview(pillImageView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(forgotPasswordButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Back button constraints
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Pill image constraints
            pillImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pillImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            pillImageView.widthAnchor.constraint(equalToConstant: 80),
            pillImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Stack view constraints
            stackView.topAnchor.constraint(equalTo: pillImageView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
    }
}
