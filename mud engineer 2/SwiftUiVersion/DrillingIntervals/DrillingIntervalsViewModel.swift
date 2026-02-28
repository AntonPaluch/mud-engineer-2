//
//  DrillingIntervalsViewModel.swift
//  mud engineer 2
//
//  Created by Павлов Дмитрий on 03.01.2025.
//

import SwiftUI

class DrillingIntervalsViewModel: ObservableObject {
    @Published var intervalsDict: [String: DrillingIntervalModel] = [:]
    
    private let storage = DrillingIntervalsStorage()
    
    init() {
        intervalsDict = storage.loadData()
    }
    
    func save() {
        storage.saveData(intervalsDict)
    }
    
    /// Получить или создать пустую модель для указанного типа
    func model(for intervalType: DrillingIntervalType) -> DrillingIntervalModel {
        let model = intervalsDict[intervalType.rawValue] ?? .empty
        return model
    }
    
    /// Обновить модель для указанного типа
    func update(_ intervalType: DrillingIntervalType, with model: DrillingIntervalModel) {
        if model == .empty {
            intervalsDict.removeValue(forKey: intervalType.rawValue)
        } else {
            intervalsDict[intervalType.rawValue] = model
        }
        storage.saveData(intervalsDict)
    }

    /// Сбросить данные для указанного типа
    func reset(_ intervalType: DrillingIntervalType) {
        intervalsDict.removeValue(forKey: intervalType.rawValue)
        storage.saveData(intervalsDict)
    }
}
