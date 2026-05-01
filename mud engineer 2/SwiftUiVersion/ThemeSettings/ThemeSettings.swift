//
//  ThemeSettings.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 01.04.2023.
//

import SwiftUI
import Combine

enum ThemePalette: String, CaseIterable, Identifiable {
    case indigo
    case ocean
    case splashBlue
    case cosmicOrange

    var id: String { rawValue }

    var title: String {
        switch self {
        case .indigo:
            return L10n.tr("swiftui.palette.indigo")
        case .ocean:
            return L10n.tr("swiftui.palette.ocean")
        case .splashBlue:
            return L10n.tr("swiftui.palette.splashBlue")
        case .cosmicOrange:
            return L10n.tr("swiftui.palette.cosmicOrange")
        }
    }
}

class ThemeSettings: ObservableObject {
    static let paletteKey = "themePalette"

    @Published var isDarkModeEnabled: Bool = UserDefaults.standard.bool(forKey: "isDarkModeEnabled") {
        didSet {
            UserDefaults.standard.set(self.isDarkModeEnabled, forKey: "isDarkModeEnabled")
        }
    }

    @Published var palette: ThemePalette = ThemeSettings.storedPalette {
        didSet {
            UserDefaults.standard.set(palette.rawValue, forKey: Self.paletteKey)
        }
    }

    static var storedPalette: ThemePalette {
        let rawValue = UserDefaults.standard.string(forKey: paletteKey)
        if rawValue == "ember" {
            return .cosmicOrange
        }
        return ThemePalette(rawValue: rawValue ?? "") ?? .indigo
    }
}
