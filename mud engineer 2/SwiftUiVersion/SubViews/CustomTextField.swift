//
//  CustomTextField.swift
//  mud engineer 2
//
//  Created by Павлов Дмитрий on 13.06.2024.
//

import SwiftUI

struct CustomTextField: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    @State private var numberText: String = "500"
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(themeSettings.isDarkModeEnabled ? ThemeColors.darkBackgroundSubView : ThemeColors.lightBackgroundSubView)
                .frame(height: 50)
            HStack {
                TextField("", text: $numberText)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
                    .frame(width: 90, height: 30)
                    .padding(.leading, 20)
                    .padding(.vertical, 10)
                    .multilineTextAlignment(.leading)
                Text("м")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                    .padding(.vertical, 10)
                    .padding(.leading, 5)
                Spacer()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray, lineWidth: 1)
        )
        .frame(width: 150, height: 85)
    }
}

#Preview {
    CustomTextField()
}
