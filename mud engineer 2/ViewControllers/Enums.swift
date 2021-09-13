//
//  Enums.swift
//  HW8TW
//
//  Created by user on 21.02.2021.
//

import Foundation

enum WeightComponents: Double, CaseIterable {
  case mramor = 2.7
  case barit = 4.3
  case dolomit = 2.9
  case siderit = 3.8
  
  var valueForComponents: String {
    switch self {
    case .mramor:
      return "Микрокальцит 2,7 г/см3"
    case .barit:
      return "Барит 4,3 г/см3 "
    case .dolomit:
      return "Доломит 2,9 г/см3"
    case .siderit:
      return "Сидерит 3,8 г/см3"
    }
  }
}
