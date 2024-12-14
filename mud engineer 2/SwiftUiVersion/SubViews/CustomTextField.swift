//
//  CustomTextField.swift
//  mud engineer 2
//
//  Created by Павлов Дмитрий on 13.06.2024.
//

import SwiftUI

struct CustomTextField: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    
    @FocusState.Binding var focusedField: DrillingIntervals.Field? // Привязка к глобальному фокусу
    var currentField: DrillingIntervals.Field // Уникальный идентификатор поля
    
    var firstLabel: String
    var secondLabel: String
    
    @State private var numberText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Заголовок поля
            Text(firstLabel)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(
                    themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
            
            // Поле ввода
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(themeSettings.isDarkModeEnabled ? ThemeColors.darkBackgroundSubView : ThemeColors.lightBackgroundSubView)
                    .frame(height: 50)
                
                HStack {
                    TextField("", text: $numberText)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                        .focused($focusedField, equals: currentField) // Привязываем фокус
                    Text(secondLabel)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(
                            themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                }
                .padding(.horizontal, 10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        .padding(.horizontal, 1)
    }
}

