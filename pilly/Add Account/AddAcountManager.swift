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
        
        guard let phone = addView.phoneTextField.text, !password.isEmpty else {
          showAlert(message: "Please enter a phone number.")
          return
        }
        
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
            let newUser = User(name: name, email: email.lowercased())
            self.addNewUserToFirestore(newUser: newUser)
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
            try userRef.setData(from: newUser) { [weak self] error in
                guard let self = self else { return }
                
                self.hideActivityIndicator()
                
                if let error = error {
                    self.showAlert(message: "Error creating user: \(error.localizedDescription)")
                    return
                }
                
                // Post notification that user registered successfully
                self.notificationCenter.post(name: .userRegistered, object: nil)
                
                // Navigate back to main screen
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            hideActivityIndicator()
            showAlert(message: "Error encoding user data")
        }
    }
}
