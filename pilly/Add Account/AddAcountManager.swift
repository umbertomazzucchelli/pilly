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
import FirebaseStorage


extension AddAccountViewController {
    func addNewAccount() {
        guard let email = addView.emailTextField.text,
              let password = addView.passwordTextField.text else { return }
        
        // Create user with Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            
            // Upload the profile image to Firebase Storage if an image was selected
            if let image = self.pickedImage,
               let imageData = image.jpegData(compressionQuality: 0.8) {
                let storageRef = Storage.storage().reference().child("profileImages/\(authResult!.user.uid).jpg")
                
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        self.showAlert(message: "Error uploading image: \(error.localizedDescription)")
                        return
                    }
                    
                    // Get the image download URL
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            self.showAlert(message: "Error getting image URL: \(error.localizedDescription)")
                            return
                        }
                        
                        // Save user data to Firestore
                        let userData: [String: Any] = [
                            "email": email,
                            "phone": self.addView.phoneTextField.text ?? "",
                            "name": self.addView.nameTextField.text ?? "",
                            "profileImageUrl": url?.absoluteString ?? ""
                        ]
                        
                        Firestore.firestore().collection("users").document(authResult!.user.uid).setData(userData) { error in
                            if let error = error {
                                self.showAlert(message: "Error saving user data: \(error.localizedDescription)")
                            } else {
                                // Notify the delegate of success
                                self.delegate?.didCompleteAccountCreation()
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            } else {
                // If no image was picked, just save the other user data
                let userData: [String: Any] = [
                    "email": email,
                    "phone": self.addView.phoneTextField.text ?? "",
                    "name": self.addView.nameTextField.text ?? ""
                ]
                
                Firestore.firestore().collection("users").document(authResult!.user.uid).setData(userData) { error in
                    if let error = error {
                        self.showAlert(message: "Error saving user data: \(error.localizedDescription)")
                    } else {
                        // Notify the delegate of success
                        self.delegate?.didCompleteAccountCreation()
                        self.navigationController?.popViewController(animated: true)
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
                print("Error updating profile: \(error.localizedDescription)")
                self?.showAlert(message: "Error updating profile name.")
            }
        }
    }
    
    func addNewUserToFirestore(userId: String, newUser: User) {
        let userRef = database.collection("users").document(userId)
        
        do {
            try userRef.setData(from: newUser) { error in
                if let error = error {
                    print("Error saving user data to Firestore: \(error.localizedDescription)")
                } else {
                    print("User data successfully saved to Firestore.")
                }
            }
        } catch {
            print("Error encoding user data: \(error.localizedDescription)")
        }
    }
    func navigateToMainTabBarController() {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let mainTabBarController = MainTabBarController()
                window.rootViewController = mainTabBarController
                window.makeKeyAndVisible()
                delegate?.didCompleteAccountCreation()
            }
        }
}
