//
//  signInViewController.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 10/25/24.
//

import UIKit

class signInViewController: UIViewController {
    // MARK: - Properties
    private let loginView = signInView()
    
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
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func forgotPasswordTapped() {
        // Handle forgot password action
    }
}

// MARK: - UITextFieldDelegate
extension signInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.usernameTextField {
            loginView.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            // Handle login action
        }
        return true
    }
}
