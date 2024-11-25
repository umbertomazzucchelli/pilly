//
//  AddAccountViewController.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 11/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Combine

class AddAccountViewController: UIViewController {
    
    let addView = AddAccountView()
    let childProgressView = ProgressSpinnerViewController()
    let database = Firestore.firestore()
    let notificationCenter = NotificationCenter.default

    
    override func loadView() {
        view = addView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Add target for register button
        addView.createAccountButton.addTarget(self, action: #selector(onCreateAccountButton), for: .touchUpInside)
        setupNavigation()
    }
    
    @objc func onCreateAccountButton() {
        // Validate inputs
        guard validateName(addView.nameTextField),
              validateEmail(addView.emailTextField),
              validatePassword(addView.passwordTextField),
              validatePhone(addView.phoneTextField) else {
            return
        }

        // Start registration process
        addNewAccount()
    }
    
    func validateName(_ textField: UITextField) -> Bool {
        guard let name = textField.text, !name.isEmpty else {
            showAlert(message: "Name is required.")
            return false
        }
        return true
    }

    func validateEmail(_ textField: UITextField) -> Bool {
        guard let email = textField.text, !email.isEmpty, isValidEmail(email) else {
            showAlert(message: "Please enter a valid email address.")
            return false
        }
        return true
    }

    func validatePassword(_ textField: UITextField) -> Bool {
        guard let password = textField.text, !password.isEmpty, password.count >= 6 else {
            showAlert(message: "Password must be at least 6 characters long.")
            return false
        }
        return true
    }
    func validatePhone(_ textField: UITextField) -> Bool {
        guard let phone = textField.text, !phone.isEmpty, phone.count >= 10 else {
            showAlert(message: "Phone number must be 10 characters long.")
            return false
        }
        return true
        
    }
    

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    private func setupNavigation() {
        title = "Add New Account"
        // This ensures the navigation bar is visible
        navigationController?.navigationBar.isHidden = false
        // This removes the "Back" text and just shows the arrow
        navigationItem.backButtonDisplayMode = .minimal
    }
}
