//
//  ThemeColors.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 01.04.2023.
//

import SwiftUI

struct ThemeColors {
    static var lightBackground: Color { palette.lightBackground }
    static var darkBackground: Color { palette.darkBackground }

    static let lightText = Color.white
    static let lightTextOpacity = Color.white.opacity(0.4)
    static var darkText: Color { palette.darkText }

    static var lightBackgroundSubView: Color { palette.lightBackgroundSubView }
    static var darkBackgroundSubView: Color { palette.darkBackgroundSubView }

    static var buttonSettings: Color { palette.accent }
    static var settingsThemeTogleView: Color { palette.accent }
    static var backgroundTextField: Color { palette.inputAccent }

    static func previewAccent(for palette: ThemePalette) -> Color {
        colors(for: palette).accent
    }

    private static var palette: PaletteColors {
        colors(for: ThemeSettings.storedPalette)
    }

    private static func colors(for palette: ThemePalette) -> PaletteColors {
        switch palette {
        case .indigo:
            return PaletteColors(
                lightBackground: Color(red: 0.973, green: 0.976, blue: 0.976),
                darkBackground: Color(red: 0.051, green: 0.102, blue: 0.157),
                lightBackgroundSubView: Color.white,
                darkBackgroundSubView: Color.white.opacity(0.12),
                darkText: Color(red: 0.157, green: 0.216, blue: 0.29),
                accent: Color(red: 0.345, green: 0.337, blue: 0.839),
                inputAccent: Color(red: 0.392, green: 0.435, blue: 1)
            )
        case .ocean:
            return PaletteColors(
                lightBackground: Color(red: 0.933, green: 0.973, blue: 0.969),
                darkBackground: Color(red: 0.024, green: 0.106, blue: 0.133),
                lightBackgroundSubView: Color.white,
                darkBackgroundSubView: Color(red: 0.761, green: 0.925, blue: 0.902).opacity(0.14),
                darkText: Color(red: 0.071, green: 0.196, blue: 0.224),
                accent: Color(red: 0, green: 0.522, blue: 0.486),
                inputAccent: Color(red: 0.051, green: 0.635, blue: 0.576)
            )
        case .cosmicOrange:
            return PaletteColors(
                lightBackground: Color(red: 0.992, green: 0.961, blue: 0.925),
                darkBackground: Color(red: 0.09, green: 0.075, blue: 0.059),
                lightBackgroundSubView: Color.white,
                darkBackgroundSubView: Color(red: 1, green: 0.8, blue: 0.55).opacity(0.14),
                darkText: Color(red: 0.22, green: 0.14, blue: 0.08),
                accent: Color(red: 0.953, green: 0.392, blue: 0),
                inputAccent: Color(red: 1, green: 0.502, blue: 0.102)
            )
        }
    }
}

private struct PaletteColors {
    let lightBackground: Color
    let darkBackground: Color
    let lightBackgroundSubView: Color
    let darkBackgroundSubView: Color
    let darkText: Color
    let accent: Color
    let inputAccent: Color
}
