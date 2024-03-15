//
//  PrototipView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 18.04.2023.
//

import SwiftUI

struct CustomDoubleTextField: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    @State private var firstTextField: String = "13313"
    @State private var secondTextField: String = "5454"
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                    .fill(themeSettings.isDarkModeEnabled ? ThemeColors.darkBackgroundSubView : ThemeColors.lightBackgroundSubView)
                .frame(height: 50)
            
            HStack {
                TextField("", text: $firstTextField)
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 25))
                    .padding(.leading, 20)
                    .onChange(of: firstTextField) { newValue in
                        if newValue.count > 5 {
                            firstTextField = String(newValue.prefix(5))
                        }
                    }
                Text("м")
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                    .padding(.trailing, 20)
                    .padding(.leading, 8)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                RoundedRectangle(cornerRadius: 1)
                                    .frame(width: 1, height: 50)
                                    .foregroundColor(Color.gray)
                
                TextField("0", text: $secondTextField)
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 25))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .padding(.leading, 20)
                    .onChange(of: secondTextField) { newValue in
                        if newValue.count > 5 {
                            secondTextField = String(newValue.prefix(5))
                        }
                    }
                
                Text("мм")
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                    .padding(.trailing, 20)
                    .font(.system(size: 14))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 1)
        )
        .frame(height: 50)
        .padding(.leading, 5)
//        .background(themeSettings.isDarkModeEnabled ? ThemeColors.darkBackgroundSubView : ThemeColors.lightBackgroundSubView)
//        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    CustomDoubleTextField()
        .environmentObject(ThemeSettings())
}

