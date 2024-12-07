//
//  AddAccountViewController.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 11/4/24.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import PhotosUI
import UIKit

protocol AddAccountDelegate: AnyObject {
    func didCompleteAccountCreation()
    //    func didAddAccount()
}

class AddAccountViewController: UIViewController {

    let addView = AddAccountView()
    let childProgressView = ProgressSpinnerViewController()
    let database = Firestore.firestore()
    let notificationCenter = NotificationCenter.default

    var pickedImage: UIImage?
    weak var delegate: AddAccountDelegate?

    override func loadView() {
        view = addView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addView.createAccountButton.addTarget(
            self, action: #selector(onCreateAccountButton), for: .touchUpInside)
        addView.profileImageButton.addTarget(
            self, action: #selector(profileImageTapped), for: .touchUpInside)

        setupNavigation()
        addView.profileImageButton.menu = getMenuImagePicker()
    }

    @objc func onCreateAccountButton() {
        guard validateName(addView.firstNameTextField),
              validateName(addView.lastNameTextField),
              validateEmail(addView.emailTextField),
              validatePassword(addView.passwordTextField),
              validatePhone(addView.phoneTextField)
        else {
            return
        }
        addNewAccount()
    }
    @objc func profileImageTapped() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    func getMenuImagePicker() -> UIMenu {
        let menuItems = [
            UIAction(
                title: "Camera",
                handler: { (_) in
                    self.pickUsingCamera()
                }),
            UIAction(
                title: "Gallery",
                handler: { (_) in
                    self.pickPhotoFromGallery()
                }),
        ]

        return UIMenu(title: "Select source", children: menuItems)
    }

    func pickUsingCamera() {
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }

    func pickPhotoFromGallery() {
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1

        let photoPicker = PHPickerViewController(configuration: configuration)
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }

    func validateName(_ textField: UITextField) -> Bool {
        // Original validation for single nameTextField
        guard let firstName = addView.firstNameTextField.text,
              let lastName = addView.lastNameTextField.text,
              !firstName.isEmpty,
              !lastName.isEmpty else {
            showAlert(message: "First and last name are required.")
            return false
        }
        return true
    }

    func validateEmail(_ textField: UITextField) -> Bool {
        guard let email = textField.text, !email.isEmpty, isValidEmail(email)
        else {
            showAlert(message: "Please enter a valid email address.")
            return false
        }
        return true
    }

    func validatePassword(_ textField: UITextField) -> Bool {
        guard let password = textField.text, !password.isEmpty,
            password.count >= 6
        else {
            showAlert(message: "Password must be at least 6 characters long.")
            return false
        }
        return true
    }

    func validatePhone(_ textField: UITextField) -> Bool {
        guard let phone = textField.text, !phone.isEmpty, phone.count >= 10
        else {
            showAlert(message: "Phone number must be 10 characters long.")
            return false
        }
        return true
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(
            with: email)
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
        navigationController?.navigationBar.isHidden = false
        navigationItem.backButtonDisplayMode = .minimal
    }

    //    func addNewAccount() {
    //        guard let email = addView.emailTextField.text,
    //              let password = addView.passwordTextField.text else { return }
    //
    //        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
    //            guard let self = self else { return }
    //
    //            if let error = error {
    //                self.showAlert(message: error.localizedDescription)
    //                return
    //            }
    //
    //            // Notify the delegate of success
    //            self.delegate?.didCompleteAccountCreation()
    //
    //            // Optionally pop back to the previous screen
    //            self.navigationController?.popViewController(animated: true)
    //        }
    //    }
}
