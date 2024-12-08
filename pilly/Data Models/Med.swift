//
//  Med.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/29/24.
//

import Foundation

struct Med: Codable {
    var id: String?
    var title: String?
    var amount: String?
    var dosage: Dosage?
    var frequency: Frequency?
    var time: String?
    var isChecked: Bool
    var checkedDates: [Date: Bool]
    var startDate: Date?

    init(id: String? = nil,
         title: String? = nil,
         amount: String? = nil,
         dosage: Dosage? = nil,
         frequency: Frequency? = nil,
         time: String? = nil,
         isChecked: Bool = false,
         checkedDates: [Date: Bool] = [:],
         startDate: Date? = nil) {
        self.id = id
        self.title = title
        self.amount = amount
        self.dosage = dosage
        self.frequency = frequency
        self.time = time
        self.isChecked = isChecked
        self.checkedDates = checkedDates
        self.startDate = startDate
    }
}
