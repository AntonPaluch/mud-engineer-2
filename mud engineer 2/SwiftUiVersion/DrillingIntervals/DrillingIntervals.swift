//
//  DrillingIntervals.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 16.04.2023.
//

import SwiftUI

import SwiftUI

struct DrillingIntervals: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeSettings: ThemeSettings
    @EnvironmentObject var unitSettings: UnitSettings
    var title: String
    
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
                    presentationMode.wrappedValue.dismiss()
                    feedbackGenerator.notificationOccurred(.success)
                }) {
                    Image(themeSettings.isDarkModeEnabled ? "backButtonDark" : "backButton")
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                }
                Text(title)
                    .font(.title)
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                    .padding(.top, 32)
                
                ScrollView {
                    Spacer()
                    
                    VStack() {
                        HStack() {
                            Text("Предыдущая колонна")
                                .foregroundColor(
                                    themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                                .font(.system(size: 16, weight: .medium))
                            Text("(не обяз.)")
                                .foregroundColor(
                                    themeSettings.isDarkModeEnabled ? ThemeColors.lightText.opacity(0.4) : ThemeColors.darkText)
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                        }
                        .padding(.bottom, 16)
                        
                        CustomDoubleTextField(firstLabel: "Длина", secondLabel: "Внутр. диаметр")
                        CustomTextField()
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .padding(.trailing, 25)
            .padding(.leading, 25)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: EmptyView())
    }
}


struct DrillingIntervals_Previews: PreviewProvider {
    static var previews: some View {
        DrillingIntervals(title: "Хвостовик")
            .environmentObject(ThemeSettings())
            .environmentObject(UnitSettings())
    }
}
