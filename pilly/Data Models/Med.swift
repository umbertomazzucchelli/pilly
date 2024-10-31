//
//  Med.swift
//  pilly
//
//  Created by Samantha Ranjo on 10/29/24.
//

import Foundation

struct Med {
    var title: String?
    var dosage: String?
    var time: String?
    
    init(title: String? = nil, dosage: String? = nil, time: String? = nil){
        self.title = title
        self.dosage = dosage
        self.time = time
    }
}
