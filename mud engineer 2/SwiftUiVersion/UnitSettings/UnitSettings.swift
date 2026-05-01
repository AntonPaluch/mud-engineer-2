//
//  UnitSettings.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 16.04.2023.
//

import Foundation

enum MeasurementSystem: String {
    case metric
    case imperial

    private enum Constants {
        static let cubicMetersPerBarrel = 0.158987294928
        static let ppgPerGramPerCubicCentimeter = 8.345404452
        static let litersPerSecondPerGpm = 0.0630901964
        static let kilogramsToPounds = 2.2046226218
        static let feetToMeters = 0.3048
        static let inchesToMillimeters = 25.4
    }

    var lengthUnit: String {
        switch self {
        case .metric: return L10n.tr("swiftui.unit.meter")
        case .imperial: return "ft"
        }
    }

    var diameterUnit: String {
        switch self {
        case .metric: return L10n.tr("swiftui.unit.millimeter")
        case .imperial: return "in"
        }
    }

    var volumeUnit: String {
        switch self {
        case .metric: return L10n.tr("swiftui.unit.cubicMeter")
        case .imperial: return "bbl"
        }
    }

    var flowRateUnit: String {
        switch self {
        case .metric: return L10n.tr("swiftui.unit.litersPerSecond")
        case .imperial: return "gpm"
        }
    }

    var densityUnit: String {
        switch self {
        case .metric: return L10n.tr("swiftui.unit.gramPerCubicCentimeter")
        case .imperial: return "ppg"
        }
    }

    var massUnit: String {
        switch self {
        case .metric: return L10n.tr("swiftui.unit.kilogram")
        case .imperial: return "lb"
        }
    }

    func lengthToMeters(_ value: Double) -> Double {
        switch self {
        case .metric: return value
        case .imperial: return value * Constants.feetToMeters
        }
    }

    func diameterToMillimeters(_ value: Double) -> Double {
        switch self {
        case .metric: return value
        case .imperial: return value * Constants.inchesToMillimeters
        }
    }

    func volumeToCubicMeters(_ value: Double) -> Double {
        switch self {
        case .metric: return value
        case .imperial: return value * Constants.cubicMetersPerBarrel
        }
    }

    func volumeFromCubicMeters(_ value: Double) -> Double {
        switch self {
        case .metric: return value
        case .imperial: return value / Constants.cubicMetersPerBarrel
        }
    }

    func flowRateToLitersPerSecond(_ value: Double) -> Double {
        switch self {
        case .metric: return value
        case .imperial: return value * Constants.litersPerSecondPerGpm
        }
    }

    func densityToGramPerCubicCentimeter(_ value: Double) -> Double {
        switch self {
        case .metric: return value
        case .imperial: return value / Constants.ppgPerGramPerCubicCentimeter
        }
    }

    func densityFromGramPerCubicCentimeter(_ value: Double) -> Double {
        switch self {
        case .metric: return value
        case .imperial: return value * Constants.ppgPerGramPerCubicCentimeter
        }
    }

    func massFromKilograms(_ value: Double) -> Double {
        switch self {
        case .metric: return value
        case .imperial: return value * Constants.kilogramsToPounds
        }
    }
}

class UnitSettings: ObservableObject {
    private enum Keys {
        static let system = "measurementSystem"
        static let legacyImperial = "isImperialEnabled"
    }

    private static let calculationStorageKeys = [
        "DrillingIntervalsData",
        "DilutionData",
        "WeightingData"
    ]

    @Published private(set) var system: MeasurementSystem {
        didSet {
            UserDefaults.standard.set(system.rawValue, forKey: Keys.system)
            UserDefaults.standard.set(system == .imperial, forKey: Keys.legacyImperial)
        }
    }

    @Published private(set) var resetVersion = 0

    var isImperialEnabled: Bool {
        get { system == .imperial }
        set { setSystem(newValue ? .imperial : .metric) }
    }

    init() {
        if let rawSystem = UserDefaults.standard.string(forKey: Keys.system),
           let storedSystem = MeasurementSystem(rawValue: rawSystem) {
            system = storedSystem
        } else {
            system = UserDefaults.standard.bool(forKey: Keys.legacyImperial) ? .imperial : .metric
        }
    }

    func setSystem(_ newSystem: MeasurementSystem) {
        guard newSystem != system else { return }
        system = newSystem
        resetCalculationData()
    }

    private func resetCalculationData() {
        for key in Self.calculationStorageKeys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        resetVersion += 1
    }
}
