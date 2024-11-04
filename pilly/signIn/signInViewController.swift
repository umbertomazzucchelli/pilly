//
//  signInViewController.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 10/25/24.
//

import UIKit

class SignInViewController: UIViewController {
    // MARK: - Properties
    private let loginView = SignInView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupDelegates() {
        loginView.usernameTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    private func setupActions() {
        loginView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        loginView.forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        loginView.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func forgotPasswordTapped() {
        // Handle forgot password action
        // Present forgot password flow
    }
    
    @objc private func signInButtonTapped() {
        loginView.hideError()
        
        guard let username = loginView.usernameTextField.text, !username.isEmpty else {
            loginView.showError("Please enter your username or email")
            return
        }
        
        guard let password = loginView.passwordTextField.text, !password.isEmpty else {
            loginView.showError("Please enter your password")
            return
        }
        
        // Show loading state
        loginView.setLoading(true)
        
        // Simulate network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.loginView.setLoading(false)
            // Handle actual authentication here
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.usernameTextField {
            loginView.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signInButtonTapped()
        }
        return true
    }
}
