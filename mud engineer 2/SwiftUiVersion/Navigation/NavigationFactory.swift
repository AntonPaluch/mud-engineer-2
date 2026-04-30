//
//  NavigationFactory.swift
//  mud engineer 2
//
//  Created by Architecture Improvement.
//

import SwiftUI

struct NavigationFactory {
    @MainActor
    static func view(
        for destination: NavigationDestination,
        drillingViewModel: DrillingIntervalsViewModel
    ) -> some View {
        switch destination {
        case .settings:
            return AnyView(
                SettingsView()
            )

        case .drillingInterval(let type, let title):
            return AnyView(
                DrillingIntervals(title: title, intervalType: type)
                    .environmentObject(drillingViewModel)
            )
            
        case .dilution:
            return AnyView(
                DilutionView()
            )
        }
    }
}

