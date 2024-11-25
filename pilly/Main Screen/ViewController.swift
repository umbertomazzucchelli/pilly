//
//  ViewController.swift
//  pilly
//
//  Created by Belen Tesfaye on 10/24/24.
//
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    let mainScreen = MainScreenView()
    let notificationCenter = NotificationCenter.default
    var currentUser: FirebaseAuth.User?
    var handleAuth: AuthStateDidChangeListenerHandle?
    let database = Firestore.firestore()

    override func loadView() {
        view = mainScreen
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pilly"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        mainScreen.signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        mainScreen.addAccountButton.addTarget(self, action: #selector(addAccountTapped), for: .touchUpInside)
        
   
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
            self?.navigationController?.pushViewController(addAccountVC, animated: true)
        }
        
        signInAlert.addAction(signInAction)
        signInAlert.addAction(registerAction)
        
        self.present(signInAlert, animated: true)
    }
    func signInToFirebase(email: String, password: String) {
        // Check if email and password are not empty
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
            self?.notificationCenter.post(name: .userLoggedin, object: nil)
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
    @objc func signInTapped(){
        
        presentLoginScreen()
        
    }
    
    @objc func addAccountTapped(){
        
    }
}

