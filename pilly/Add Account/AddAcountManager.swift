//
//  AddAcountManager.swift
//  pilly
//
//  Created by Belen Tesfaye on 11/24/24.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Foundation

extension AddAccountViewController {
    func addNewAccount() {
        guard let email = addView.emailTextField.text,
              let password = addView.passwordTextField.text,
              let firstName = addView.firstNameTextField.text,
              let lastName = addView.lastNameTextField.text
        else { return }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }

            guard let userId = authResult?.user.uid else {
                self.showAlert(message: "User ID not found.")
                return
            }

            if let image = self.pickedImage,
               let imageData = image.jpegData(compressionQuality: 0.8) {
                // Upload profile image
                let storageRef = Storage.storage().reference().child("profileImages/\(userId).jpg")
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        self.showAlert(message: "Error uploading image: \(error.localizedDescription)")
                        return
                    }

                    storageRef.downloadURL { url, error in
                        if let error = error {
                            self.showAlert(message: "Error getting image URL: \(error.localizedDescription)")
                            return
                        }
                        let profileImageUrl = url?.absoluteString ?? ""
                        self.saveUserData(
                            userId: userId,
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            profileImageUrl: profileImageUrl
                        )
                    }
                }
            } else {
                // Save user data without profile image
                self.saveUserData(
                    userId: userId,
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    profileImageUrl: nil
                )
            }
        }
    }

    private func saveUserData(userId: String, firstName: String, lastName: String, email: String, profileImageUrl: String?) {
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "phone": addView.phoneTextField.text ?? "",
            "profileImageUrl": profileImageUrl ?? ""
        ]

        Firestore.firestore().collection("users").document(userId).setData(userData) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(message: "Error saving user data: \(error.localizedDescription)")
            } else {
                self.navigateToMainTabBarController()
            }
        }
    }

    func setNameOfTheUserInFirebaseAuth(firstName: String, lastName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "\(firstName) \(lastName)"
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
