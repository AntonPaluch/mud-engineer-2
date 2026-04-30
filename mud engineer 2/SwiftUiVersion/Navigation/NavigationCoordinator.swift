//
//  NavigationCoordinator.swift
//  mud engineer 2
//
//  Created by Architecture Improvement.
//

import SwiftUI

// MARK: - Navigation Destinations
enum NavigationDestination: Hashable {
    case settings
    case drillingInterval(DrillingIntervalType, title: String)
    case dilution
    case weighting
}

// MARK: - Navigation Coordinator
@MainActor
final class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ destination: NavigationDestination) {
        path.append(destination)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
