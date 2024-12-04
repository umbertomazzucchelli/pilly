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
    var name: String
    var email: String
    var phone: String? // Optional phone field

    init(name: String, email: String, phone: String? = nil) {
        self.name = name
        self.email = email
        self.phone = phone
    }
}
