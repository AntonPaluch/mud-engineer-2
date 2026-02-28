//
//  AppMain.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 01.04.2023.
//

import SwiftUI
import IQKeyboardManagerSwift
import YandexMobileMetrica

@main
struct MyApp: App {
    @StateObject private var themeSettings = ThemeSettings()
    @StateObject private var unitSettings = UnitSettings()
    @StateObject private var navigationCoordinator = NavigationCoordinator()
    @StateObject private var drillingViewModel = DrillingIntervalsViewModel()
        
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationCoordinator.path) {
                MainView()
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        NavigationFactory.view(
                            for: destination,
                            drillingViewModel: drillingViewModel
                        )
                    }
            }
            .environmentObject(themeSettings)
            .environmentObject(unitSettings)
            .environmentObject(navigationCoordinator)
            .environmentObject(drillingViewModel)
        }
    }
    
    init() {
//        configureApp()
        requestNotificationPermission()
    }
    
    private func requestNotificationPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted {
                    print("Разрешение на уведомления предоставлено.")
                } else {
                    print("Разрешение на уведомления отклонено.")
                }
            }
        }
    
    private func configureApp() {
        Thread.sleep(forTimeInterval: 0.5)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow

        configureAnalytic()
        YMMYandexMetrica.reportEvent("Запуск приложеньки")
    }

    private func configureAnalytic() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "b030a454-cc2f-4784-a65e-6d9db5271e05") else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
