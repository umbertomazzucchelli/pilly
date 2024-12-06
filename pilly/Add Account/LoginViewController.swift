//
//  LoginViewController.swift
//  pilly
//
//  Created by Belen Tesfaye on 12/3/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, AddAccountDelegate {
    func didCompleteAccountCreation() {
        let medMainVC = HomeViewController()  // Initialize your MedMainViewController
        navigationController?.pushViewController(medMainVC, animated: true)
    }
    
    let mainScreenView = MainScreenView()
    let notificationCenter = NotificationCenter.default
    var loginSuccessMessageLabel: UILabel!  // Label for the success message
    
    override func loadView() {
        view = mainScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        
        
        loginSuccessMessageLabel = UILabel()
        loginSuccessMessageLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        loginSuccessMessageLabel.textAlignment = .center
        loginSuccessMessageLabel.textColor = .green
        loginSuccessMessageLabel.isHidden = true  // Hide it initially
        view.addSubview(loginSuccessMessageLabel)
    }

    
    func presentLoginScreen() {
        let signInAlert = UIAlertController(
            title: "Welcome",
            message: "Please sign in or register to continue",
            preferredStyle: .alert)
        
        signInAlert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        
        signInAlert.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        let signInAction = UIAlertAction(title: "Sign In", style: .default) { [weak self] _ in
            if let email = signInAlert.textFields?[0].text,
               let password = signInAlert.textFields?[1].text {
                self?.signInToFirebase(email: email, password: password)
            }
        }
        
        let registerAction = UIAlertAction(title: "Register", style: .default) { [weak self] _ in
            let addAccountVC = AddAccountViewController()
            addAccountVC.delegate = self
            self?.navigationController?.pushViewController(addAccountVC, animated: true)
        }
        
        signInAlert.addAction(signInAction)
        signInAlert.addAction(registerAction)
        
        self.present(signInAlert, animated: true)
    }

    func signInToFirebase(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(message: "Please enter your email and password.") { [weak self] _ in
                self?.presentLoginScreen()
            }
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showAlert(message: error.localizedDescription) { [weak self] _ in
                    self?.presentLoginScreen()
                }
                return
            }
            
            // Show success message
            self?.showLoginSuccessMessage()
            
            // Post notification to notify user logged in
            self?.notificationCenter.post(name: .userLoggedin, object: nil)
            
            // Replace the root view controller with ViewController
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let viewController = ViewController()
                let navigationController = UINavigationController(rootViewController: viewController)
                appDelegate.window?.rootViewController = navigationController
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    func showLoginSuccessMessage() {
        loginSuccessMessageLabel.text = "Login Successful"
        loginSuccessMessageLabel.isHidden = false
        
        // Hide the label after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.loginSuccessMessageLabel.isHidden = true
        }
    }
    
    func showAlert(message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completionHandler))
        present(alert, animated: true)
    }
    
 

}
