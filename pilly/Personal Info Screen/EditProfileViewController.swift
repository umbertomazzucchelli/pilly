//
//  EditProfileViewController.swift
//  pilly
//
//  Created by Belen Tesfaye on 12/5/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class EditProfileViewController: UIViewController {
    
    // UI Elements
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var phoneTextField: UITextField!
    var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        loadCurrentUserData()
    }
    
    private func setupUI() {
        // Initialize text fields
        nameTextField = createTextField(placeholder: "Name")
        emailTextField = createTextField(placeholder: "Email")
        phoneTextField = createTextField(placeholder: "Phone")
        
        // Initialize update button
        updateButton = UIButton(type: .system)
        updateButton.setTitle("Update", for: .normal)
        updateButton.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(updateButton)
        
        // Layout text fields and button
        let stackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, phoneTextField, updateButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            phoneTextField.heightAnchor.constraint(equalToConstant: 40),
            updateButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    private func loadCurrentUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching user data: \(error)")
                return
            }
            
            if let document = document, document.exists {
                if let data = document.data() {
                    self?.nameTextField.text = data["name"] as? String
                    self?.emailTextField.text = data["email"] as? String
                    self?.phoneTextField.text = data["phone"] as? String
                }
            }
        }
    }
    
    @objc private func updateProfile() {
        let alert = UIAlertController(title: "Confirm Changes", message: "Are you sure you want to update your profile?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            self?.saveChanges()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func saveChanges() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        let updatedData: [String: Any] = [
            "name": nameTextField.text ?? "",
            "email": emailTextField.text ?? "",
            "phone": phoneTextField.text ?? ""
        ]
        
        db.collection("users").document(userId).updateData(updatedData) { error in
            if let error = error {
                print("Error updating profile: \(error)")
                return
            }
            
            print("Profile successfully updated!")
            self.navigationController?.popViewController(animated: true)
        }
    }
}
