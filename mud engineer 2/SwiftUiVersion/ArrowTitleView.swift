//
//  ArrowTitleView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 01.04.2023.
//

import SwiftUI

struct ArrowTitleView: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    let title: String
    let imageName: String

    var body: some View {
        HStack {
            Text(title)
                .font(.custom("SFUIDisplay-Regular", fixedSize: 16))
                .padding(.leading, 20)
                .foregroundColor(themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
            Spacer()
            Image(imageName)
                .padding(.trailing, 20)
        }
        .frame(height: 60)
        .background(themeSettings.isDarkModeEnabled ? ThemeColors.darkBackgroundSubView : ThemeColors.lightBackgroundSubView)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(ThemeColors.buttonSettings.opacity(themeSettings.isDarkModeEnabled ? 0.24 : 0.14), lineWidth: 1)
        )
        .cornerRadius(14)
        .shadow(color: ThemeColors.buttonSettings.opacity(themeSettings.isDarkModeEnabled ? 0.18 : 0.08), radius: 8, x: 0, y: 4)
    }
}

struct ArrowTitleView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowTitleView(title: "Кондуктор", imageName: "arrowRight")
            .previewLayout(.sizeThatFits)
    }
}
