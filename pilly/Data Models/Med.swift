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
    var completionDates: [String: Bool]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case amount
        case dosage
        case frequency
        case time
        case completionDates
    }

    init(id: String? = nil,
         title: String? = nil,
         amount: String? = nil,
         dosage: Dosage? = nil,
         frequency: Frequency? = nil,
         time: String? = nil,
         completionDates: [String: Bool] = [:]) {
        self.id = id
        self.title = title
        self.amount = amount
        self.dosage = dosage
        self.frequency = frequency
        self.time = time
        self.completionDates = completionDates
    }

    func isCompleted(for date: Date) -> Bool {
        let dateString = Med.dateFormatter.string(from: date)
        return completionDates[dateString] ?? false
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
