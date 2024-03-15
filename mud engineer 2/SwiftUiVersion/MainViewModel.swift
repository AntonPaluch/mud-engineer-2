//
//  MainViewModel.swift
//  mud engineer 2
//
//  Created by Павлов Дмитрий on 15.03.2024.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var themeSettings: ThemeSettings
    @Published var unitSettings: UnitSettings

    init(themeSettings: ThemeSettings, unitSettings: UnitSettings) {
        self.themeSettings = themeSettings
        self.unitSettings = unitSettings
    }
}
