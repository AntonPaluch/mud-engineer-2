//
//  MainView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 01.04.2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var unitSettings: UnitSettings
    @EnvironmentObject var themeSettings: ThemeSettings
    
    @State private var isShowingDetailsView = false
        
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
    private var textColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText
    }
    
    private var iconName: String {
        themeSettings.isDarkModeEnabled ? "arrowRightDarkTheme" : "arrowRight"
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text(Texts.mudFluid)
                        .foregroundColor(textColor)
                        .font(.system(size: 16, weight: .regular))
                        .lineLimit(1)
                    NavigationLink(
                        destination: SettingsView(isShowingDetailsView: $isShowingDetailsView),
                        isActive: $isShowingDetailsView
                    ) { EmptyView() }
                    Spacer()
                    Button(action: {
                        self.isShowingDetailsView = true
                        feedbackGenerator.notificationOccurred(.success)
                    }) {
                        Image(themeSettings.isDarkModeEnabled ? "settingsDarkTheme" : "settings")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .padding(.top, 25)
                                
                Text(Texts.сalculation)
                    .font(.system(size: 22, weight: .semibold, design: .default))
                    .padding(.top, 30)
                    .foregroundColor(textColor)

                Text(Texts.wellFlushing)
                    .font(.system(size: 16, weight: .regular))
                    .padding(.top, 27)
                    .padding(.bottom, 21)
                    .foregroundColor(textColor)

                VStack(spacing: 10) {
                NavigationLink(destination: DrillingIntervals(title: Texts.conductor)) {
                    ArrowTitleView(
                        title: Texts.conductor,
                        imageName: iconName
                    )
                }

                NavigationLink(destination: DrillingIntervals(title: Texts.productionString)) {
                    ArrowTitleView(
                        title: Texts.productionString,
                        imageName: iconName
                    )
                }

                NavigationLink(destination: DrillingIntervals(title: Texts.shank)) {
                    ArrowTitleView(
                        title: Texts.shank,
                        imageName: iconName
                    )
                }
            }
                Text(Texts.mud)
                    .font(.system(size: 16, weight: .regular))
                    .padding(.top, 34)
                    .padding(.bottom, 21)
                    .foregroundColor(textColor)
                
                VStack(spacing: 10) {
                    ArrowTitleView(
                        title: Texts.dilution,
                        imageName: iconName
                    )

                    ArrowTitleView(
                        title: Texts.weighting,
                        imageName: iconName
                    )
                }
                Spacer()

            }
            .navigationBarHidden(true)
            .padding(25)
            .edgesIgnoringSafeArea(.all)
            .background(themeSettings.isDarkModeEnabled ? ThemeColors.darkBackground : ThemeColors.lightBackground)
            .preferredColorScheme(.light)
        }
    }
    
//    func startCountdownActivity() {
//        let attributes = MudFluidActivityAttributes(name: "Timer")
//        let initialContentState = MudFluidActivityAttributes.ContentState(emoji: "⏳")
//        
//        do {
//            // Запускаем Live Activity
//            let activity = try Activity<MudFluidActivityAttributes>.request(
//                attributes: attributes,
//                contentState: initialContentState,
//                pushType: nil
//            )
//            
//            Task {
//                // Запускаем таймер, обновляем каждую секунду
//                for seconds in stride(from: 59, through: 0, by: -1) {
//                    try await Task.sleep(nanoseconds: 1_000_000_000)
//                    let updatedContentState = MudFluidActivityAttributes.ContentState(emoji: "⏳ \(seconds) сек.")
//                    await activity.update(using: updatedContentState)
//                }
//                
//                // Завершаем Live Activity
//                await activity.end(dismissalPolicy: .immediate)
//            }
//            
//        } catch {
//            print("Ошибка при создании активности: \(error)")
//        }
//    }
    
    private enum Texts {
        static let mudFluid = "Mud Fluid"
        static let сalculation = "Расчёт"
        static let wellFlushing = "Промывка скважины"
        static let conductor = "Кондуктор"
        static let productionString = "Эксплуатационная колонна"
        static let shank = "Хвостовик"
        static let dilution = "Разбавление"
        static let weighting = "Утяжеление"
        static let mud = "Раствор"
    }

}


// Определяем атрибуты для таймера
//struct TimerAttributes: ActivityAttributes {
//    public struct ContentState: Codable, Hashable {
//        var timeLeft: Int
//    }
//
//    var title: String
//}
