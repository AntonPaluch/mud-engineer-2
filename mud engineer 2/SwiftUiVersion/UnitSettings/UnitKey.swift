//
//  UnitKey.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 16.04.2023.
//

import SwiftUI

struct UnitKey: EnvironmentKey {
    static let defaultValue: UnitSettings = UnitSettings()
}

extension EnvironmentValues {
    var unitSettings: UnitSettings {
        get { self[UnitKey.self] }
        set { self[UnitKey.self] = newValue }
    }
}
