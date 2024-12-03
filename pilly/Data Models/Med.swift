//
//  Med.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/29/24.
//

import Foundation

struct Med {
    var title: String?
    var amount: String?
    var dosage: Dosage?
    var frequency: Frequency?
    var time: String?
    var isChecked: Bool
    
    init(title: String? = nil, amount: String? = nil, dosage: Dosage? = nil, frequency: Frequency? = nil,
         time: String? = nil, isChecked: Bool = false){
        self.title = title
        self.amount = amount
        self.dosage = dosage
        self.frequency = frequency
        self.time = time
        self.isChecked = isChecked
    }
}
