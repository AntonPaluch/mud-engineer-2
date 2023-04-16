//
//  SettingsThemeTogleView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 02.04.2023.
//

import SwiftUI

struct SettingsThemeTogleView: View {
    
    @Binding var isDarkModeEnabled: Bool
       
       init(isDarkModeEnabled: Binding<Bool>) {
           self._isDarkModeEnabled = isDarkModeEnabled
       }
    
    var body: some View {
        HStack {
            Button(action: {
                isDarkModeEnabled = false
            }, label: {
                Text("Светлая")
                    .font(.custom("SFUIDisplay-Medium", fixedSize: 16))
                    .foregroundColor(ThemeColors.lightText)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(isDarkModeEnabled ? Color.clear : ThemeColors.buttonSettings)
                    .cornerRadius(16)
            })
            .frame(maxWidth: .infinity)
            
            Spacer().frame(width: 5)
            
            Button(action: {
                isDarkModeEnabled = true
            }, label: {
                Text("Тёмная")
                    .font(.custom("SFUIDisplay-Medium", fixedSize: 16))
                    .foregroundColor(isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(isDarkModeEnabled ? ThemeColors.buttonSettings : Color.clear)
                    .cornerRadius(16)
            })
            .frame(maxWidth: .infinity)
        }
        .padding(5)
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(isDarkModeEnabled ? Color.white.opacity(0.1) : Color.white)
        .cornerRadius(16)
        .shadow(radius: 1)
    }
}



struct SettingsTogleView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsThemeTogleView(isDarkModeEnabled: .constant(true))
    }
}
