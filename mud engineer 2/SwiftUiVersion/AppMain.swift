//
//  AppMain.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 01.04.2023.
//

import SwiftUI
import YandexMobileMetrica

@main
struct MyApp: App {
    @StateObject private var themeSettings = ThemeSettings()
    @StateObject private var unitSettings = UnitSettings()
    @StateObject private var navigationCoordinator = NavigationCoordinator()
    @StateObject private var drillingViewModel = DrillingIntervalsViewModel()
    @State private var isShowingSplash = true
        
    var body: some Scene {
        WindowGroup {
            Group {
                if isShowingSplash {
                    SplashScreenView()
                        .ignoresSafeArea()
                } else {
                    appContent
                }
            }
            .task {
                guard isShowingSplash else { return }

                try? await Task.sleep(nanoseconds: 800_000_000)
                withAnimation(.easeOut(duration: 0.25)) {
                    isShowingSplash = false
                }

                requestNotificationPermission()
            }
            .preferredColorScheme(themeSettings.isDarkModeEnabled ? .dark : .light)
            .environmentObject(themeSettings)
            .environmentObject(unitSettings)
            .environmentObject(navigationCoordinator)
            .environmentObject(drillingViewModel)
        }
    }

    private var appContent: some View {
        NavigationStack(path: $navigationCoordinator.path) {
            MainView()
                .navigationDestination(for: NavigationDestination.self) { destination in
                    NavigationFactory.view(
                        for: destination,
                        drillingViewModel: drillingViewModel
                    )
                }
        }
    }

    init() {
//        configureAnalytic()
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

    private func configureAnalytic() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "b030a454-cc2f-4784-a65e-6d9db5271e05") else { return }
        YMMYandexMetrica.activate(with: configuration)
        YMMYandexMetrica.reportEvent("Запуск приложеньки")
    }
}

private struct SplashScreenView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color(red: 0.02, green: 0.58, blue: 0.86)
                    .ignoresSafeArea()

                Image("MudEngineerSplash")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipped()
            .ignoresSafeArea()
        }
        .background(
            Color(red: 0.02, green: 0.58, blue: 0.86)
                .ignoresSafeArea()
        )
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
