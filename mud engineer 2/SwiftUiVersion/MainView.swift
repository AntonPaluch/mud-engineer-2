//
//  MainView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 01.04.2023.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var themeSettings = ThemeSettings()
    
    @State private var isShowingDetailsView = false
    
    private let feedbackGenerator = UINotificationFeedbackGenerator()

    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {

                HStack {
                    Text("Mud Fluid")
                        .foregroundColor(
                            themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                        .font(.custom("SFUIDisplay-Medium", fixedSize: 16))
                    Spacer()
                    NavigationLink(
                        destination: SettingsView(isShowingDetailsView: $isShowingDetailsView)
                            .environmentObject(themeSettings),
                                isActive: $isShowingDetailsView) {
                                    EmptyView()
                    }
                    Button(action: {
                        self.isShowingDetailsView = true
                        feedbackGenerator.notificationOccurred(.success)
                    }) {
                        Image(themeSettings.isDarkModeEnabled ? "settingsDarkTheme" : "settings")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .padding(.top, 25)


                Text("Расчет")
                    .font(.custom("SFUIDisplay-Semibold", fixedSize: 22))
                    .padding(.top, 30)
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)

                Text("Промывка скважины")
                    .font(.custom("SFUIDisplay-Medium", fixedSize: 16))
                    .padding(.top, 27)
                    .padding(.bottom, 21)
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)

                VStack(spacing: 10) {
                    ArrowTitleView(
                        title: "Кондуктор",
                        imageName: themeSettings.isDarkModeEnabled ? "arrowRightDarkTheme" : "arrowRight")
                        .environmentObject(themeSettings)

                    ArrowTitleView(
                        title: "Эксплуатационная колонна",
                        imageName: themeSettings.isDarkModeEnabled ? "arrowRightDarkTheme" : "arrowRight")
                        .environmentObject(themeSettings)

                    ArrowTitleView(
                        title: "Хвостовик",
                        imageName: themeSettings.isDarkModeEnabled ? "arrowRightDarkTheme" : "arrowRight")
                        .environmentObject(themeSettings)

                }
                
                Text("Раствор")
                    .font(.custom("SFUIDisplay-Medium", fixedSize: 16))
                    .padding(.top, 34)
                    .padding(.bottom, 21)
                    .foregroundColor(themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                
                VStack(spacing: 10) {
                    ArrowTitleView(
                        title: "Разбавление",
                        imageName: themeSettings.isDarkModeEnabled ? "arrowRightDarkTheme" : "arrowRight")

                    ArrowTitleView(
                        title: "Утяжеление",
                        imageName: themeSettings.isDarkModeEnabled ? "arrowRightDarkTheme" : "arrowRight")
                }
                Spacer()

            }
            .padding(25)
            .edgesIgnoringSafeArea(.all)
            .background(themeSettings.isDarkModeEnabled ? ThemeColors.darkBackground : ThemeColors.lightBackground)
            // Отмена системной темы (поставили светлую по умолчанию)
            .preferredColorScheme(.light)
        }
        .environmentObject(themeSettings)
    }

}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//            .environmentObject(ThemeSettings())
//    }
//}


