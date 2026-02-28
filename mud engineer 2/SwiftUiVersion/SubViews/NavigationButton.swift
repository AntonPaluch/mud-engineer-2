//
//  NavigationButton.swift
//  mud engineer 2
//
//  Created by Architecture Improvement.
//

import SwiftUI

struct NavigationButton: View {
    @EnvironmentObject var themeSettings: ThemeSettings

    let title: String
    let iconName: String
    let action: () -> Void

    private let feedbackGenerator = UINotificationFeedbackGenerator()

    private var textColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText
    }

    var body: some View {
        Button(action: {
            feedbackGenerator.notificationOccurred(.success)
            action()
        }) {
            ArrowTitleView(
                title: title,
                imageName: iconName
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


