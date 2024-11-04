//
//  signInView.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 10/25/24.
//

import UIKit

class SignInView: UIView {
    // MARK: - UI Components
    private(set) lazy var pillImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "pill-icon")
        imageView.tintColor = .systemBlue
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = "Pilly App Logo"
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
        textField.placeholder = "Username/Email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.accessibilityIdentifier = "usernameTextField"
        textField.font = .preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    
    private(set) lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.isSecureTextEntry = true
        textField.accessibilityIdentifier = "passwordTextField"
        textField.font = .preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    
    private(set) lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private(set) lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
    
    private(set) lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private(set) lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot password?", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private(set) lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Back"
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
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(forgotPasswordButton)
        
        signInButton.addSubview(activityIndicator)
        
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
            
            // Activity indicator constraints
            activityIndicator.centerXAnchor.constraint(equalTo: signInButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Public Methods
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func hideError() {
        errorLabel.isHidden = true
    }
    
    func setLoading(_ isLoading: Bool) {
        signInButton.isEnabled = !isLoading
        if isLoading {
            activityIndicator.startAnimating()
            signInButton.setTitle("", for: .normal)
        } else {
            activityIndicator.stopAnimating()
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
}
