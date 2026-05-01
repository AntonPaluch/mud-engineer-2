//
//  SettingsPaletteToggleView.swift
//  mud engineer 2
//
//  Created by Architecture Improvement.
//

import SwiftUI

struct SettingsPaletteToggleView: View {
    @EnvironmentObject var themeSettings: ThemeSettings

    private var containerColor: Color {
        themeSettings.isDarkModeEnabled ? Color.white.opacity(0.1) : Color.white
    }

    private var inactiveTextColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText
    }

    var body: some View {
        HStack(spacing: 5) {
            ForEach(ThemePalette.allCases) { palette in
                Button {
                    themeSettings.palette = palette
                } label: {
                    VStack(spacing: 6) {
                        Circle()
                            .fill(ThemeColors.previewAccent(for: palette))
                            .frame(width: 12, height: 12)

                        Text(palette.title)
                            .font(.system(size: 12, weight: .medium))
                            .lineLimit(1)
                            .minimumScaleFactor(0.72)
                    }
                    .foregroundColor(textColor(for: palette))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(background(for: palette))
                    .cornerRadius(14)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(5)
        .frame(height: 68)
        .frame(maxWidth: .infinity)
        .background(containerColor)
        .cornerRadius(16)
        .shadow(radius: 1)
    }

    private func background(for palette: ThemePalette) -> Color {
        themeSettings.palette == palette ? ThemeColors.previewAccent(for: palette) : Color.clear
    }

    private func textColor(for palette: ThemePalette) -> Color {
        themeSettings.palette == palette ? ThemeColors.lightText : inactiveTextColor
    }
}

struct SettingsPaletteToggleView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPaletteToggleView()
            .environmentObject(ThemeSettings())
            .previewLayout(.sizeThatFits)
    }
}
