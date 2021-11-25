//
//  StoreManager.swift
//  mud engineer 2
//
//  Created by Pandos on 24.11.2021.
//

import UIKit

extension KonduktorViewController {
        
    func presentValue() {
        dlinaPredKolonni.text = userDef.string(forKey: "k1")
        vnDiametrKolonni.text = userDef.string(forKey: "k2")
        dolotoMM.text = userDef.string(forKey: "k3")
        kKavernoznosty.text = userDef.string(forKey: "k4")
        diametrInstrumenta.text = userDef.string(forKey: "k5")
        stenkaInstrumentaMM.text = userDef.string(forKey: "k6")
        zaboy.text = userDef.string(forKey: "k7")
        litrazh.text = userDef.string(forKey: "k8")
    }
    
    func saveValue() {
        userDef.setValue(dlinaPredKolonni.text, forKey: "k1")
        userDef.setValue(vnDiametrKolonni.text, forKey: "k2")
        userDef.setValue(dolotoMM.text, forKey: "k3")
        userDef.setValue(kKavernoznosty.text, forKey: "k4")
        userDef.setValue(diametrInstrumenta.text, forKey: "k5")
        userDef.setValue(stenkaInstrumentaMM.text, forKey: "k6")
        userDef.setValue(zaboy.text, forKey: "k7")
        userDef.setValue(litrazh.text, forKey: "k8")
        
    }
    
    func resetValue() {
        dlinaPredKolonni.text = ""
        vnDiametrKolonni.text = ""
        dolotoMM.text = ""
        kKavernoznosty.text = ""
        diametrInstrumenta.text = ""
        stenkaInstrumentaMM.text = ""
        zaboy.text = ""
        litrazh.text = ""
        
        userDef.removeObject(forKey: "k1")
        userDef.removeObject(forKey: "k2")
        userDef.removeObject(forKey: "k3")
        userDef.removeObject(forKey: "k4")
        userDef.removeObject(forKey: "k5")
        userDef.removeObject(forKey: "k6")
        userDef.removeObject(forKey: "k7")
        userDef.removeObject(forKey: "k8")
    }
}
