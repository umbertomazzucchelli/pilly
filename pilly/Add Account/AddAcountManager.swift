//
//  AddAcountManager.swift
//  pilly
//
//  Created by Belen Tesfaye on 11/24/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

extension AddAccountViewController {
    func addNewAccount() {
        guard let name = addView.nameTextField.text, !name.isEmpty else {
            showAlert(message: "Please enter your name.")
            return
          }
          
        guard let email = addView.emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter your email address.")
            return
            }

        guard let password = addView.passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter a password.")
            return
            }
        
        // Phone is optional, so it will included it only if it's not empty
        let phone = addView.phoneTextField.text?.isEmpty == false ? addView.phoneTextField.text : nil
        
        // Show progress indicator
        showActivityIndicator()
        
        // Create Firebase user
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.hideActivityIndicator()
                self.showAlert(message: error.localizedDescription)
                return
            }
            
            // Set user's display name
            self.setNameOfTheUserInFirebaseAuth(name: name)
            
            // Create user document in Firestore
            let newUser = User(name: name, email: email.lowercased(), phone: phone)
            self.addNewUserToFirestore(newUser: newUser)
            
            self.notificationCenter.post(name: .userRegistered, object: nil)
            
            // Hide progress indicator
            self.hideActivityIndicator()
            
            // Automatically sign in the user after account creation
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] signInResult, signInError in
                if let error = signInError {
                    self?.showAlert(message: "Account created but couldn't sign in:  \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                   // Get the current window scene and switch to main tab bar controller
                   if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first {
                       let mainTabBarController = MainTabBarController()
                       window.rootViewController = mainTabBarController
                       window.makeKeyAndVisible()
                       
                       // Notify delegate of completion
                       self?.delegate?.didCompleteAccountCreation()
                   }
               }
            }
        }
    }
    
    func setNameOfTheUserInFirebaseAuth(name: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { [weak self] error in
            if let error = error {
                print("Error updating profile: \(error)")
                self?.showAlert(message: "Error updating profile name")
            }
        }
    }
    
    func addNewUserToFirestore(newUser: User) {
        let userRef = database.collection("users").document(newUser.email.lowercased())
        
        do {
            try userRef.setData(from: newUser) { error in
                if let error = error {
                    print("Error creating user document: \(error)")
                }
            }
        } catch {
            print("Error encoding user data: \(error)")
        }
    }
}
