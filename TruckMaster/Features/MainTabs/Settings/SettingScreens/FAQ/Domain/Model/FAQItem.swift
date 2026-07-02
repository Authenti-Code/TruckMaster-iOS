//
//  FAQItem.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

import Foundation

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    var isExpanded: Bool = false
}
