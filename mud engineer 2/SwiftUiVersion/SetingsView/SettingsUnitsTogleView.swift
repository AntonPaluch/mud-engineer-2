//
//  SettingsUnitsTogleView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 02.04.2023.
//

import SwiftUI

struct SettingsUnitsTogleView: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    @EnvironmentObject var unitSettings: UnitSettings
    @EnvironmentObject var drillingViewModel: DrillingIntervalsViewModel
    
    var body: some View {
        HStack {
            Button(action: {
                select(.metric)
            }, label: {
                Text(Texts.metric)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor((!unitSettings.isImperialEnabled || themeSettings.isDarkModeEnabled) ? ThemeColors.lightText : ThemeColors.darkText)
                                
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(unitSettings.isImperialEnabled ? Color.clear : ThemeColors.buttonSettings)
                    .cornerRadius(16)
            })
            .frame(maxWidth: .infinity)
            
            Spacer().frame(width: 5)
            
            Button(action: {
                select(.imperial)
            }, label: {
                Text(Texts.imperial)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor((unitSettings.isImperialEnabled || themeSettings.isDarkModeEnabled) ? ThemeColors.lightText : ThemeColors.darkText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(unitSettings.isImperialEnabled ? ThemeColors.buttonSettings : Color.clear)
                    .cornerRadius(16)
            })
            .frame(maxWidth: .infinity)
        }
        .padding(5)
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(themeSettings.isDarkModeEnabled ? Color.white.opacity(0.1) : Color.white)
        .cornerRadius(16)
        .shadow(radius: 1)
    }
    
    private enum Texts {
        static let metric = "Метрические"
        static let imperial = "Имперские"
    }

    private func select(_ system: MeasurementSystem) {
        guard unitSettings.system != system else { return }
        unitSettings.setSystem(system)
        drillingViewModel.clearAll()
    }
}

struct SettingsUnitsTogleView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsUnitsTogleView()
            .environmentObject(ThemeSettings())
            .environmentObject(UnitSettings())
            .environmentObject(DrillingIntervalsViewModel())
    }
}
