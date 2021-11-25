//
//  Enumeration.swift
//  mud engineer 2
//
//  Created by Pandos on 22.11.2021.
//

import Foundation

enum AllInterval: String, CaseIterable {
    case konduktor = "Кондуктор"
    case kolonna = "Эксплуатационная колонна"
    case hvost = "Хвостовик"
    
    func convertString() -> String {
        switch self {
        case .konduktor:
            return NSLocalizedString("konduktor", comment: "")
        case .kolonna:
            return NSLocalizedString("kolonna", comment: "")
        case .hvost:
            return NSLocalizedString("hvost", comment: "")
        }
    }
}

