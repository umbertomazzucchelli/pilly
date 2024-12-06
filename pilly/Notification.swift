//
//  Notification.swift
//  pilly
//
//  Created by Belen Tesfaye on 11/24/24.
//

import Foundation
extension Notification.Name{
    
    static let userRegistered = Notification.Name("userRegistered")
    static let userLoggedin = Notification.Name("userLoggedin")
    static let userLoggedout = Notification.Name("userLoggedout")
    static let placesFromMap = Notification.Name("placesFromMap")
    static let medicationsUpdated = Notification.Name("medicationsUpdated")
    
    func editMedication(med: Med?) {
        NotificationCenter.default.post(name: Notification.Name("MedicationClicked"), object: med)
    }



    
    
}
