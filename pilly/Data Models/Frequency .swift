//
//  Frequency .swift
//  pilly
//
//  Created by Belen Tesfaye on 12/2/24.
//

import Foundation

enum Frequency: String, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case biWeekly = "Bi-Weekly"

    static let allFrequencies = [daily, weekly, biWeekly]
}
