//
//  CalculatorManager.swift
//  Промывка скважины 2.0
//
//  Created by Pandos on 17.04.2021.
//

import Foundation

class CalculationManager {

    private func parse(_ value: String) -> Double? {
        let normalized = value
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard let number = Double(normalized), number.isFinite else { return nil }
        return number
    }
    
    func vKolonny(vnDiametrKolonni: String, dlinaKolonni: String) -> String {
        guard let diameter = parse(vnDiametrKolonni), diameter > 0,
              let length = parse(dlinaKolonni), length > 0 else {
            return "0.00"
        }

        let diameterMeters = diameter / 1000
        let volume = Double.pi / 4 * pow(diameterMeters, 2) * length
        return String(format: "%.2f", volume)
    }
    
    func vOtkritiStvol(dDolota: String, zaboy: String, dlinaKolonni: String, kKavernoznosty: String) -> String {
        guard let bitDiameter = parse(dDolota), bitDiameter > 0,
              let depth = parse(zaboy), depth > 0 else {
            return "0.00"
        }

        let previousColumnLength = max(parse(dlinaKolonni) ?? 0, 0)
        let cavernosity = max(parse(kKavernoznosty) ?? 1, 0)
        let openHoleLength = max(depth - previousColumnLength, 0)
        let bitDiameterMeters = bitDiameter / 1000
        let volume = Double.pi / 4 * pow(bitDiameterMeters, 2) * openHoleLength * cavernosity
        return String(format: "%.2f", volume)
    }
    
    func metalSbt(dInstrumenta: String, stenkaSbt: String, zaboy: String) -> String {
        guard let outerDiameter = parse(dInstrumenta), outerDiameter > 0,
              let wallThickness = parse(stenkaSbt), wallThickness > 0,
              let depth = parse(zaboy), depth > 0 else {
            return "0.00"
        }

        let innerDiameter = outerDiameter - 2 * wallThickness
        guard innerDiameter > 0 else { return "0.00" }

        let outerDiameterMeters = outerDiameter / 1000
        let innerDiameterMeters = innerDiameter / 1000
        let outerArea = Double.pi / 4 * pow(outerDiameterMeters, 2)
        let innerArea = Double.pi / 4 * pow(innerDiameterMeters, 2)
        let volume = max(outerArea - innerArea, 0) * depth
        return String(format: "%.2f", volume)
    }
    
    func vRastvoraVtrubax(dInstrumenta: String, stenkaSbt: String, zaboy: String) -> String {
        guard let outerDiameter = parse(dInstrumenta), outerDiameter > 0,
              let wallThickness = parse(stenkaSbt), wallThickness > 0,
              let depth = parse(zaboy), depth > 0 else {
            return "0.00"
        }

        let innerDiameter = outerDiameter - 2 * wallThickness
        guard innerDiameter > 0 else { return "0.00" }

        let innerDiameterMeters = innerDiameter / 1000
        let volume = Double.pi / 4 * pow(innerDiameterMeters, 2) * depth
        return String(format: "%.2f", volume)
    }
    
    func rascetChikla(vihodZaboynoy: Double, prokachkaDozaboy: Double) -> String {
        let summa = vihodZaboynoy + prokachkaDozaboy
        return String(format: "%.2f", summa)
    }

    func weightingAgentMass(
        volume: Double,
        startDensity: Double,
        finishDensity: Double,
        componentDensity: Double
    ) -> Double {
        guard volume > 0,
              startDensity > 0,
              finishDensity > startDensity,
              componentDensity > finishDensity else {
            return 0
        }

        let componentDensityKgM3 = componentDensity * 1000
        let mass = componentDensityKgM3 * (finishDensity - startDensity) / (componentDensity - finishDensity) * volume
        return mass
    }

    func weightedMudVolume(
        volume: Double,
        weightingAgentMass: Double,
        componentDensity: Double
    ) -> Double {
        guard volume > 0, weightingAgentMass >= 0, componentDensity > 0 else {
            return 0
        }

        return volume + (weightingAgentMass / (componentDensity * 1000))
    }
        
}
