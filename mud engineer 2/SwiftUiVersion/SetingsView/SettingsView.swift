//
//  SettingsView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 01.04.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    @Binding var isShowingDetailsView: Bool
    
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    
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
                    }) {
                        Image(themeSettings.isDarkModeEnabled ? "backButtonDark" : "backButton")
                            .resizable()
                            .frame(width: 40, height: 40)
                            
                    }
                    Text("Настройки")
                        .font(.title)
                        .foregroundColor(
                            themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                        .padding(.top, 32)
                    
                    Text("Тема")
                        .font(.subheadline)
                        .foregroundColor(
                            themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                        .padding(.top, 35)
                                                        
                    SettingsThemeTogleView(isDarkModeEnabled: $themeSettings.isDarkModeEnabled)
                        .padding(.top, 15)
                                
                    Text("Единицы измерения")
                        .font(.subheadline)
                        .foregroundColor(
                            themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isShowingDetailsView: .constant(true))
            .environmentObject(ThemeSettings())
    }
}
