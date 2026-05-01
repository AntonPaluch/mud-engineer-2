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
    
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @EnvironmentObject var drillingVM: DrillingIntervalsViewModel
        
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
    private var textColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText
    }
    
    private var iconName: String {
        themeSettings.isDarkModeEnabled ? "arrowRightDarkTheme" : "arrowRight"
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(Texts.mudFluid)
                    .foregroundColor(textColor)
                    .font(.system(size: 16, weight: .regular))
                    .lineLimit(1)
                Spacer()
                Button(action: {
                    navigationCoordinator.push(.settings)
                    feedbackGenerator.notificationOccurred(.success)
                }) {
                    Image(themeSettings.isDarkModeEnabled ? "settingsDarkTheme" : "settings")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .aspectRatio(contentMode: .fit)
                }
            }
            .padding(.top, 40)

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
                NavigationButton(title: Texts.conductor, iconName: iconName) {
                    navigationCoordinator.push(.drillingInterval(.conductor, title: Texts.conductor))
                }
                NavigationButton(title: Texts.productionString, iconName: iconName) {
                    navigationCoordinator.push(.drillingInterval(.production, title: Texts.productionString))
                }
                NavigationButton(title: Texts.shank, iconName: iconName) {
                    navigationCoordinator.push(.drillingInterval(.liner, title: Texts.shank))
                }
            }

            Text(Texts.mud)
                .font(.system(size: 16, weight: .regular))
                .padding(.top, 34)
                .padding(.bottom, 21)
                .foregroundColor(textColor)

            VStack(spacing: 10) {
                NavigationButton(title: Texts.dilution, iconName: iconName) {
                    navigationCoordinator.push(.dilution)
                }
                NavigationButton(title: Texts.weighting, iconName: iconName) {
                    navigationCoordinator.push(.weighting)
                }
            }

            Spacer()
        }
        .navigationBarHidden(true)
        .padding(25)
        .edgesIgnoringSafeArea(.all)
        .background(themeSettings.isDarkModeEnabled ? ThemeColors.darkBackground : ThemeColors.lightBackground)
        .preferredColorScheme(themeSettings.isDarkModeEnabled ? .dark : .light)
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
        static var сalculation: String { L10n.tr("swiftui.calculation") }
        static var wellFlushing: String { L10n.tr("wellFlushing") }
        static var conductor: String { L10n.tr("konduktor") }
        static var productionString: String { L10n.tr("kolonna") }
        static var shank: String { L10n.tr("hvost") }
        static var dilution: String { L10n.tr("swiftui.dilution.short") }
        static var weighting: String { L10n.tr("swiftui.weighting.short") }
        static var mud: String { L10n.tr("swiftui.mud") }
    }

}

enum L10n {
    static func tr(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
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
