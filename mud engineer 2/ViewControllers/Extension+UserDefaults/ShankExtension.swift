//
//  ShankVCextension.swift
//  mud engineer 2
//
//  Created by Pandos on 25.11.2021.
//

import Foundation

extension ShankVC {
    
    func presentValue() {
        longColumn.text = userDef.string(forKey: "s1")
        inDiametrColumn.text = userDef.string(forKey: "s2")
        wellBottom.text = userDef.string(forKey: "s3")
        diametrDrilling.text = userDef.string(forKey: "s4")
        kCavernosity.text = userDef.string(forKey: "s5")
        diametrDrillingPipes.text = userDef.string(forKey: "s6")
        wallThickness.text = userDef.string(forKey: "s7")
        pumpLiters.text = userDef.string(forKey: "s8")
    }
    func saveValue() {
        userDef.setValue(longColumn.text, forKey: "s1")
        userDef.setValue(inDiametrColumn.text, forKey: "s2")
        userDef.setValue(wellBottom.text, forKey: "s3")
        userDef.setValue(diametrDrilling.text, forKey: "s4")
        userDef.setValue(kCavernosity.text, forKey: "s5")
        userDef.setValue(diametrDrillingPipes.text, forKey: "s6")
        userDef.setValue(wallThickness.text, forKey: "s7")
        userDef.setValue(pumpLiters.text, forKey: "s8")
    }
    func resetValue() {
        longColumn.text = ""
        inDiametrColumn.text = ""
        wellBottom.text = ""
        diametrDrilling.text = ""
        kCavernosity.text = ""
        diametrDrillingPipes.text = ""
        wallThickness.text = ""
        pumpLiters.text = ""
        
        userDef.removeObject(forKey: "s1")
        userDef.removeObject(forKey: "s2")
        userDef.removeObject(forKey: "s3")
        userDef.removeObject(forKey: "s4")
        userDef.removeObject(forKey: "s5")
        userDef.removeObject(forKey: "s6")
        userDef.removeObject(forKey: "s7")
        userDef.removeObject(forKey: "s8")
    }
}
