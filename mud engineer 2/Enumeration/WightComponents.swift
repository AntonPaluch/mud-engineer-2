
import Foundation

enum WeightComponents: Double, CaseIterable {
  case mramor = 2.7
  case barit = 4.3
  case dolomit = 2.9
  case siderit = 3.8
  
  var valueForComponents: String {
    switch self {
    case .mramor:
        return NSLocalizedString("calcium", comment: "")
    case .barit:
      return NSLocalizedString("barit", comment: "")
    case .dolomit:
      return NSLocalizedString("dolomite", comment: "")
    case .siderit:
      return NSLocalizedString("siderite", comment: "")
    }
  }
}
