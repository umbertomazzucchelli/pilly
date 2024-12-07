//
//  LoginViewController.swift
//  pilly
//
//  Created by Belen Tesfaye on 12/3/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, AddAccountDelegate {
    let mainScreenView = MainScreenView()
    let notificationCenter = NotificationCenter.default
    var loginSuccessMessageLabel: UILabel!  // Label for the success message
    
    override func loadView() {
        view = mainScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        setupLoginSuccessLabel()
    }
    
    private func setupLoginSuccessLabel() {
        loginSuccessMessageLabel = UILabel()
        loginSuccessMessageLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        loginSuccessMessageLabel.textAlignment = .center
        loginSuccessMessageLabel.textColor = .green
        loginSuccessMessageLabel.isHidden = true
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
        present(signInAlert, animated: true)
    }

    func signInToFirebase(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(message: "Please enter your email and password.")
            return
        }

        AuthManager.shared.signIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.showLoginSuccessMessage()
                NotificationManager.shared.post(name: .userLoggedin)
                
                DispatchQueue.main.async {
                    let mainTabBarController = MainTabBarController()
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = mainTabBarController
                        window.makeKeyAndVisible()
                    }
                }
                
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func didCompleteAccountCreation() {
        let mainTabBarController = MainTabBarController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = mainTabBarController
            window.makeKeyAndVisible()
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
