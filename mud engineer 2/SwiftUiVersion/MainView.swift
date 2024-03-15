//
//  MainView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 01.04.2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var unitSettings: UnitSettings
    
    @EnvironmentObject var themeSettings: ThemeSettings
    
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
                        .lineLimit(1)
                    NavigationLink(
                        destination: SettingsView(isShowingDetailsView: $isShowingDetailsView)
                            .environmentObject(themeSettings)
                            .environmentObject(UnitSettings()),
                                isActive: $isShowingDetailsView) {
                                    EmptyView()
                    }
                    Spacer()
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
                
                Text("Расчёт")
                    .font(.system(size: 22, weight: .semibold, design: .default))
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
                NavigationLink(destination: DrillingIntervals(title: "Кондуктор")
                                .environmentObject(themeSettings)
                                .environmentObject(unitSettings)) {
                    ArrowTitleView(
                        title: "Кондуктор",
                        imageName: themeSettings.isDarkModeEnabled ? "arrowRightDarkTheme" : "arrowRight")
                        .environmentObject(themeSettings)
                }

                NavigationLink(destination: DrillingIntervals(title: "Эксплуатационная колонна")
                                .environmentObject(themeSettings)
                                .environmentObject(unitSettings)) {
                    ArrowTitleView(
                        title: "Эксплуатационная колонна",
                        imageName: themeSettings.isDarkModeEnabled ? "arrowRightDarkTheme" : "arrowRight")
                        .environmentObject(themeSettings)
                }

                NavigationLink(destination: DrillingIntervals(title: "Хвостовик")
                                .environmentObject(themeSettings)
                                .environmentObject(unitSettings)) {
                    ArrowTitleView(
                        title: "Хвостовик",
                        imageName: themeSettings.isDarkModeEnabled ? "arrowRightDarkTheme" : "arrowRight")
                        .environmentObject(themeSettings)
                }
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
            .navigationBarHidden(true)
            .padding(25)
            .edgesIgnoringSafeArea(.all)
            .background(themeSettings.isDarkModeEnabled ? ThemeColors.darkBackground : ThemeColors.lightBackground)
            // Отмена системной темы (поставили светлую по умолчанию)
            .preferredColorScheme(.light)
        }
        .environmentObject(themeSettings)
        .environmentObject(unitSettings)
    }

}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//            .environmentObject(ThemeSettings())
//    }
//}


