//
//  ThemeSettings.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 01.04.2023.
//

import SwiftUI
import Combine

class ThemeSettings: ObservableObject {
    @Published var isDarkModeEnabled: Bool = UserDefaults.standard.bool(forKey: "isDarkModeEnabled") {
        didSet {
            UserDefaults.standard.set(self.isDarkModeEnabled, forKey: "isDarkModeEnabled")
        }
    }
}
