//
//  PersonalInfoView.swift
//  My_Profile
//
//  Created by MAD4 on 11/25/24.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth


class PersonalInfoView: UIView {
    // Labels to display user info
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var phoneLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
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
        
        // Add constraints for the labels
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            phoneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
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
            
            // Fetch the user data from Firestore using the userID
            db.collection("users").document(userId).getDocument { [weak self] document, error in
                if let error = error {
                    print("Error getting document: \(error)")
                    return
                }
                
                if let document = document, document.exists {
                    do {
                        let user = try document.data(as: User.self)
                        // Bind the data to the labels
                        self?.nameLabel.text = "Name: \(user.name ?? "N/A")"
                        self?.emailLabel.text = "Email: \(user.email ?? "N/A")"
                        self?.phoneLabel.text = "Phone: \(user.phone ?? "N/A")"
                    } catch {
                        print("Error decoding user data: \(error)")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
