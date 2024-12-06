//
//  PersonalInfoView.swift
//  My_Profile
//
//  Created by MAD4 on 11/25/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PersonalInfoView: UIView {
    
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var phoneLabel: UILabel!
    var photoImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailLabel)
        
        phoneLabel = UILabel()
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(phoneLabel)
        
        photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 50 // Circular image
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            phoneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            phoneLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user is signed in.")
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    
                    // Bind the data to the labels
                    self?.nameLabel.text = "Name: \(user.name)"
                    self?.emailLabel.text = "Email: \(user.email)"
                    self?.phoneLabel.text = "Phone: \(user.phone ?? "N/A")"
                    
                } catch {
                    print("Error decoding user data: \(error)")
                }
            } else {
                print("Document does not exist, creating new document.")
                
                if let currentUser = Auth.auth().currentUser {
                    let name = currentUser.displayName ?? "Unknown Name"
                    let email = currentUser.email ?? "Unknown Email"
                    let phone = currentUser.phoneNumber
                    
                    self?.createUserDocument(userId: userId, name: name, email: email, phone: phone)
                }
            }
        }
    }

    
    func createUserDocument(userId: String, name: String, email: String, phone: String?) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.setData([
            "name": name,
            "email": email,
            "phone": phone ?? "",
            "photoURL": ""
        ]) { error in
            if let error = error {
                print("Error creating user document: \(error)")
            } else {
                print("User document successfully created!")
            }
        }
    }
    
    func loadProfilePhoto(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Fetch the image from the URL
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error loading profile photo: \(error)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.photoImageView.image = image
                }
            }
        }.resume()
    }
}


