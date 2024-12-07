//
//  User.swift
//  pilly
//
//  Created by Belen Tesfaye on 11/24/24.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var id: String?
    var firstName: String
    var lastName: String
    var email: String
    var phone: String?
    var profileImageUrl: String?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(firstName: String, lastName: String, email: String, phone: String?, profileImageUrl: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.profileImageUrl = profileImageUrl
    }
}
