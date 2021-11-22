//
//  UserActions.swift
//  mud engineer 2
//
//  Created by Pandos on 22.11.2021.
//

import Foundation

enum UserActions: String, CaseIterable {
    case wellFlushing
    case dilutionFluid
    case weighting
    case preferenceVC
    
    func labelEnum() -> String {
        switch self {
        case .wellFlushing:
            return NSLocalizedString("wellFlushing", comment: "")
        case .dilutionFluid:
            return NSLocalizedString("dilutionFluid", comment: "")
        case .weighting:
            return NSLocalizedString("weighting", comment: "")
        case .preferenceVC:
            return NSLocalizedString("preferenceVC", comment: "")
        }
    }
}
