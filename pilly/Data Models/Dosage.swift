//
//  Dosage.swift
//  pilly
//
//  Created by Belen Tesfaye on 12/2/24.
//

import Foundation

enum Dosage: String, Codable {
    case mg = "mg"
    case mcg = "mcg"
    case g = "g"
    case mL = "mL"
    case percent = "%"

    static let allDosages = [mg, mcg, g, mL, percent]
}
