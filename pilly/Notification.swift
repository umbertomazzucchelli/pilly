//
//  Notification.swift
//  pilly
//
//  Created by Belen Tesfaye on 11/24/24.
//

import Foundation
extension Notification.Name{
    static let startMessageWithSelected = Notification.Name("startMessageWithSelected")
    static let userRegistered = Notification.Name("userRegistered")
    static let userLoggedin = Notification.Name("userLoggedin")
    static let userLoggedout = Notification.Name("userLoggedout")
    static let messageUpdated = Notification.Name("messageUpdated")
    static let medsUpdated = Notification.Name("medsUpdated")
}
