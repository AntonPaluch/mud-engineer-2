//
//  CalculatorManager.swift
//  Промывка скважины 2.0
//
//  Created by Pandos on 17.04.2021.
//

import Foundation

class CalculationManager {
    
    func vKolonny(vnDiametrKolonni: String, dlinaKolonni: String) -> String {
        let v1 = ((Double(vnDiametrKolonni) ?? 1.0) / 1000) * ((Double(vnDiametrKolonni) ?? 1.0) / 1000)
        let v2 = 0.785 * v1
        let v3 = round(v2 * (Double(dlinaKolonni) ?? 1.0))
        return String(v3)
    }
    
    func vOtkritiStvol(dDolota: String, zaboy: String, dlinaKolonni: String, kKavernoznosty: String) -> String {
        // dDolota: 295.3, zaboy:1000, dlinaKolonni:50, kKavernoznosty: 1.3
        let dlina = (Double(zaboy) ?? 1.0) - (Double(dlinaKolonni) ?? 1.0)
        // 1000 - 50 = 950 +
        let kvadrat = ((Double(dDolota) ?? 1.0) / 1000) * ((Double(dDolota) ?? 1.0) / 1000)
        // 0,087 +
        let vOtkrit = 0.785 * kvadrat * dlina * (Double(kKavernoznosty) ?? 1.0)
        return String(format: "%.2f", vOtkrit)
    }
    
    func metalSbt(dInstrumenta: String, stenkaSbt: String, zaboy: String) -> String {
        // dInstr = 127, stenka = 8, zaboy = 1000
        let n1 = pow(((Double(dInstrumenta) ?? 1.0) / 1000), 2)
        //0,016 +
//        let n2 = pow(((Double(dInstrumenta) ?? 1.0) - (2 * (Double(stenkaSbt) ?? 1.0)) / 1000), 2)
        let n2 = ((Double(dInstrumenta) ?? 1.0) - 2 * (Double(stenkaSbt) ?? 1.0)) / 1000
        //0,111 +
        let n3 = pow(n2, 2)
        //0,0123 +
        let n4 = n1 - n3
        //0,0038 +
//        let n5 = round(0.785 * n4 * (Double(zaboy) ?? 1.0))
        let n5 = 0.785 * n4 * (Double(zaboy) ?? 1.0)

        //
        return String(format: "%.2f", n5)
        //3 +
    }
    
    func vRastvoraVtrubax(dInstrumenta: String, stenkaSbt: String, zaboy: String) -> String {
        // dInstrumenta: 127, stenkaSbt: 8, zaboy: 1000
        let n1 = 2 * (Double(stenkaSbt) ?? 1.0)
        // 16 +
        let n2 = ((Double(dInstrumenta) ?? 1.0) - n1) / 1000
        // 0.111 +
        let n3 = pow(n2, 2)
        let n4 = 0.785 * n3 * (Double(zaboy) ?? 1.0)
        return String(format: "%.2f", n4)
    }
    
   
    
   
}
