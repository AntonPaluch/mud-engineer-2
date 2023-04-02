//
//  ThemeKey.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 01.04.2023.
//

import SwiftUI

struct ThemeKey: EnvironmentKey {
    static let defaultValue: ThemeSettings = ThemeSettings()
}

extension EnvironmentValues {
    var themeSettings: ThemeSettings {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

