//
//  PrototipView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 18.04.2023.
//

import SwiftUI

struct CustomDoubleTextField: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    
    @FocusState.Binding var focusedField: DrillingIntervals.Field?
    var firstField: DrillingIntervals.Field
    var secondField: DrillingIntervals.Field
    
    var firstLabel: String
    var secondLabel: String
    
    @State private var firstTextField: String = ""
    @State private var secondTextField: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(firstLabel)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                Spacer()
                Text(secondLabel)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
            }
            .padding(.bottom, 4)
            
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(themeSettings.isDarkModeEnabled ? ThemeColors.darkBackgroundSubView : ThemeColors.lightBackgroundSubView)
                    .frame(height: 50)
                
                HStack {
                    TextField("0", text: $firstTextField)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 20))
                        .padding(.leading, 20)
                        .focused($focusedField, equals: firstField)
                    
                    Text("м")
                        .foregroundColor(
                            themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                        .padding(.leading, 5)
                    
                    RoundedRectangle(cornerRadius: 1)
                        .frame(width: 1, height: 50)
                        .foregroundColor(.gray)
                        .padding(.leading, 20)
                    
                    TextField("0", text: $secondTextField)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 20))
                        .padding(.leading, 20)
                        .focused($focusedField, equals: secondField)
                    
                    Text("мм")
                        .foregroundColor(
                            themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                        .padding(.trailing, 20)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}
