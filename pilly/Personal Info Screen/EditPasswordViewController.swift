//
//  EditPasswordViewController.swift
//  pilly
//
//  Created by Belen Tesfaye on 12/6/24.
//

import UIKit
import FirebaseAuth

class EditPasswordViewController: UIViewController {

    private let currentPasswordTextField = UITextField()
    private let newPasswordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let updateButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Password"
        view.backgroundColor = .white
        
        
        setupUI()
    }

    private func setupUI() {
        // Configure current password text field
        currentPasswordTextField.placeholder = "Current Password"
        currentPasswordTextField.isSecureTextEntry = true
        currentPasswordTextField.borderStyle = .roundedRect
        currentPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentPasswordTextField)

        newPasswordTextField.placeholder = "New Password"
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.borderStyle = .roundedRect
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newPasswordTextField)

        confirmPasswordTextField.placeholder = "Confirm New Password"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmPasswordTextField)

        updateButton.setTitle("Update Password", for: .normal)
        updateButton.backgroundColor = .systemBlue
        updateButton.layer.cornerRadius = 5
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.addTarget(self, action: #selector(updatePassword), for: .touchUpInside)
        view.addSubview(updateButton)

        NSLayoutConstraint.activate([
            currentPasswordTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            currentPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            newPasswordTextField.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 20),
            newPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            updateButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateButton.widthAnchor.constraint(equalToConstant: 200),
            updateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func updatePassword() {
        guard let currentPassword = currentPasswordTextField.text, !currentPassword.isEmpty,
              let newPassword = newPasswordTextField.text, !newPassword.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "All fields are required.")
            return
        }

        if newPassword != confirmPassword {
            showAlert(message: "New passwords do not match.")
            return
        }

        guard let user = Auth.auth().currentUser else { return }

        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)

        user.reauthenticate(with: credential) { [weak self] (result, error) in
            if let error = error {
                self?.showAlert(message: "Re-authentication failed: \(error.localizedDescription)")
                return
            }

            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    self?.showAlert(message: "Password update failed: \(error.localizedDescription)")
                    return
                }

                self?.showAlert(message: "Password updated successfully.", isSuccess: true)
            }
        }
    }

    private func showAlert(message: String, isSuccess: Bool = false) {
        let alert = UIAlertController(title: isSuccess ? "Success" : "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if isSuccess {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        present(alert, animated: true)
    }
}
