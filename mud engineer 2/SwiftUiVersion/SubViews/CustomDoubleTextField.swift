//
//  PrototipView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 18.04.2023.
//

import SwiftUI

enum Field: Hashable {
    case first
    case second
}

struct CustomDoubleTextField: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    var firstLabel: String
    var secondLabel: String
    @FocusState private var focusedField: Field?
    @State private var firstTextField: String = ""
    @State private var secondTextField: String = ""
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(firstLabel)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                Spacer()
                Spacer()
                Text(secondLabel)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                Spacer()
            }
            .padding(.bottom, 15)
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(themeSettings.isDarkModeEnabled ? ThemeColors.darkBackgroundSubView : ThemeColors.lightBackgroundSubView)
                    .frame(height: 50)
                
                HStack {
                    ZStack(alignment: .leading) {
                        if firstTextField.isEmpty {
                            Text("0")
                                .foregroundColor(.gray) // Цвет placeholder
                                .padding(.leading, 20)
                        }
                        TextField("", text: $firstTextField)
                            .foregroundColor(
                                themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 20))
                            .padding(.leading, 20)
                            .onChange(of: firstTextField) { newValue in
                                if newValue.count > 6 {
                                    firstTextField = String(newValue.prefix(6))
                                }
                            }
                            .focused($focusedField, equals: .first)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Button(action: {
                                        focusedField = (focusedField == .first) ? .second : .first
                                    }) {
                                        Text("Next")
                                    }
                                }
                            }
                            .onSubmit {
                                focusedField = .second
                            }
                    }
                    Text("м")
                        .foregroundColor(
                            themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                        .padding(.leading, 5)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                                        
                    RoundedRectangle(cornerRadius: 1)
                        .frame(width: 1, height: 50)
                        .foregroundColor(Color.gray)
                        .padding(.leading, 20)
                    
                    ZStack(alignment: .leading) {
                        if secondTextField.isEmpty {
                            Text("0")
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                        }
                        TextField("", text: $secondTextField)
                            .foregroundColor(
                                themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 20))
                            .padding(.leading, 20)
                            .onChange(of: secondTextField) { newValue in
                                if newValue.count > 6 {
                                    secondTextField = String(newValue.prefix(6))
                                }
                            }
                            .focused($focusedField, equals: .second)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Button(action: {
                                        UIApplication.shared.endEditing()
                                    }) {
                                        Text("Done")
                                    }
                                }
                            }
                            .onSubmit {
                                focusedField = .first
                            }
                    }
                    Text("мм")
                        .foregroundColor(
                            themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                        .padding(.trailing, 20)
                        .font(.system(size: 14))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .frame(height: 50)
            .padding(.leading, 1)
            .padding(.trailing, 1)
        }
    }
}

#Preview {
    CustomDoubleTextField(firstLabel: "ферстЛейбл", secondLabel: "секондЛейбл")
        .environmentObject(ThemeSettings())
}

