//
//  SettingsUnitsTogleView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 02.04.2023.
//

import SwiftUI

struct SettingsUnitsTogleView: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    
    var body: some View {
        HStack {
            Button(action: {
                print("Метрические")
            }, label: {
                Text("Метрические")
                    .font(.custom("SFUIDisplay-Medium", fixedSize: 16))
                    .foregroundColor(ThemeColors.lightText)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(themeSettings.isDarkModeEnabled ? Color.clear : ThemeColors.buttonSettings)
                    .cornerRadius(16)
            })
            .frame(maxWidth: .infinity)
            
            Spacer().frame(width: 5)
            
            Button(action: {
                print("Имперские")
            }, label: {
                Text("Имперские")
                    .font(.custom("SFUIDisplay-Medium", fixedSize: 16))
                    .foregroundColor(themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(themeSettings.isDarkModeEnabled ? ThemeColors.buttonSettings : Color.clear)
                    .cornerRadius(16)
            })
            .frame(maxWidth: .infinity) // Добавить этот модификатор
        }
        .padding(5) // Задает отступы по краям View равными 5 поинтам
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(themeSettings.isDarkModeEnabled ? Color.white.opacity(0.1) : Color.white)
        .cornerRadius(16)
        .shadow(radius: 1)
    }
}

struct SettingsUnitsTogleView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsUnitsTogleView()
            .environmentObject(ThemeSettings())
    }
}
