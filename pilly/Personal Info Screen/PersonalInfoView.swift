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
    
    // Labels to display user info
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var phoneLabel: UILabel!
    var photoImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        // Set up the labels
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailLabel)
        
        phoneLabel = UILabel()
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(phoneLabel)
        
        // Set up the profile photo image view
        photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 50 // Circular image
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photoImageView)
        
        // Add constraints for the labels and photo
        NSLayoutConstraint.activate([
            // Profile photo constraints
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Name label constraints
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Email label constraints
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Phone label constraints
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            phoneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            phoneLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Function to load user data from Firestore
    func loadUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user is signed in.")
            return
        }
        
        let db = Firestore.firestore()
        
        // Fetch the user data from Firestore using the userID
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            // Check if the document exists
            if let document = document, document.exists {
                do {
                    // Decode user data from Firestore
                    let user = try document.data(as: User.self)
                    
                    // Bind the data to the labels
                    self?.nameLabel.text = "Name: \(user.name)"
                    self?.emailLabel.text = "Email: \(user.email)"
                    self?.phoneLabel.text = "Phone: \(user.phone ?? "N/A")"
                    
                } catch {
                    print("Error decoding user data: \(error)")
                }
            } else {
                // Handle case where document does not exist
                print("Document does not exist, creating new document.")
                
                // Fetch data from Firebase Authentication
                if let currentUser = Auth.auth().currentUser {
                    let name = currentUser.displayName ?? "Unknown Name"
                    let email = currentUser.email ?? "Unknown Email"
                    let phone = currentUser.phoneNumber
                    
                    // Create a new user document with the fetched data
                    self?.createUserDocument(userId: userId, name: name, email: email, phone: phone)
                }
            }
        }
    }

    
    // Function to create a user document after registration (for the first-time user)
    func createUserDocument(userId: String, name: String, email: String, phone: String?) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        // Set user data to Firestore
        userRef.setData([
            "name": name,
            "email": email,
            "phone": phone ?? "", // Optional phone number
            "photoURL": "" // Set empty or default URL if no photo is available
        ]) { error in
            if let error = error {
                print("Error creating user document: \(error)")
            } else {
                print("User document successfully created!")
            }
        }
    }
    
    // Function to load the profile photo using a URL
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


