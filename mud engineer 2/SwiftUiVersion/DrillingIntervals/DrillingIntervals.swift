//
//  DrillingIntervals.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 16.04.2023.
//

import SwiftUI


//
//Написать какой то enum со стейтами для каждого интервала и 
//доставать данные расчетов по каждому стейту


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
                .padding(.leading, 25)
                Text(title)
                    .font(.title)
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                    .padding(.top, 28)
                    .padding(.leading, 25)
                
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

                        Text("Открытый ствол")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(
                                themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                            .padding(.top, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            CustomTextField(firstLabel: "Забой", secondLabel: "м")
                            Spacer(minLength: 25)
                            CustomTextField(firstLabel: "Диаметр долота", secondLabel: "мм")
                        }
                        .padding(.top, 10)
                        HStack {
                            CustomTextField(firstLabel: "Коэфф. кавернозности", secondLabel: "")
                            Spacer(minLength: 25)
                            CustomTextField(firstLabel: "Стальные бур. трубы", secondLabel: "мм")
                        }
                        .padding(.top, 10)
                        HStack {
                            CustomTextField(firstLabel: "Толщина стенки", secondLabel: "мм")
                            Spacer(minLength: 25)
                            CustomTextField(firstLabel: "Литраж ( не обяз.)", secondLabel: "л/с")
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 25)

                    WashingResult()
                        .padding(.top, 40)
                    
                }
                .scrollIndicators(.hidden)
                .edgesIgnoringSafeArea(.bottom)
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
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
