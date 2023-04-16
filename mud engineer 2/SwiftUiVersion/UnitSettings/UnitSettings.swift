//
//  UnitSettings.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 16.04.2023.
//

import Foundation

class UnitSettings: ObservableObject {
    @Published var isImperialEnabled: Bool = UserDefaults.standard.bool(forKey: "isImperialEnabled") {
        didSet {
            UserDefaults.standard.set(self.isImperialEnabled, forKey: "isImperialEnabled")
        }
    }
}
