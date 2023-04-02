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
        .cornerRadius(14)
        .shadow(radius: 1)
    }
}

struct ArrowTitleView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowTitleView(title: "Кондуктор", imageName: "arrowRight")
            .previewLayout(.sizeThatFits)
    }
}
