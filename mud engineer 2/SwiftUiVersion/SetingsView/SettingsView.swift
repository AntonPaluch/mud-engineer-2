//
//  SettingsView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 01.04.2023.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isShowingDetailsView: Bool
    @EnvironmentObject var themeSettings: ThemeSettings
    @EnvironmentObject var unitSettings: UnitSettings
    
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    
    private var textColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText
    }
    
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
    var body: some View {
            ZStack {
                if themeSettings.isDarkModeEnabled {
                    ThemeColors.darkBackground
                        .edgesIgnoringSafeArea(.all)
                } else {
                    ThemeColors.lightBackground
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack(alignment: .leading) {
                    Button(action: {
                        self.isShowingDetailsView = false
                        feedbackGenerator.notificationOccurred(.success)
                    }) {
                        Image(themeSettings.isDarkModeEnabled ? "backButtonDark" : "backButton")
                            .resizable()
                            .frame(width: 40, height: 40)
                            
                    }
                    Text(Texts.settings)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(textColor)
                        .padding(.top, 32)
                    
                    Text(Texts.theme)
                        .font(.subheadline)
                        .foregroundColor(textColor)
                        .padding(.top, 28)
                                                        
                    SettingsThemeTogleView(isDarkModeEnabled: $themeSettings.isDarkModeEnabled)
                        .padding(.top, 15)
                                
                    Text(Texts.units)
                        .font(.subheadline)
                        .foregroundColor(textColor)
                        .padding(.top, 35)
                    
                    SettingsUnitsTogleView()
                        .environmentObject(themeSettings)
                        .padding(.top, 15)
                    
                    Spacer()

                }
                .padding(.trailing, 25)
                .padding(.leading, 25)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
    }
    
    private enum Texts {
        static let settings = "Настройки"
        static let theme = "Тема"
        static let units = "Единицы измерения"
    }
}
