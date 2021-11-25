//
//  ProduckColumnVC.swift
//  mud engineer 2
//
//  Created by Pandos on 25.11.2021.
//

import Foundation

extension ProductColumnVC {

  func presentValue() {
    longColumn.text = userDef.string(forKey: "c1")
    inDiametrColumn.text = userDef.string(forKey: "c2")
    wellBottom.text = userDef.string(forKey: "c3")
    diametrDrilling.text = userDef.string(forKey: "c4")
    kCavernosity.text = userDef.string(forKey: "c5")
    diametrDrillingPipes.text = userDef.string(forKey: "c6")
    wallThickness.text = userDef.string(forKey: "c7")
    pumpLiters.text = userDef.string(forKey: "c8")
  }

  func saveValue() {
    userDef.setValue(longColumn.text, forKey: "c1")
    userDef.setValue(inDiametrColumn.text, forKey: "c2")
    userDef.setValue(wellBottom.text, forKey: "c3")
    userDef.setValue(diametrDrilling.text, forKey: "c4")
    userDef.setValue(kCavernosity.text, forKey: "c5")
    userDef.setValue(diametrDrillingPipes.text, forKey: "c6")
    userDef.setValue(wallThickness.text, forKey: "c7")
    userDef.setValue(pumpLiters.text, forKey: "c8")
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
    
    userDef.removeObject(forKey: "c1")
    userDef.removeObject(forKey: "c2")
    userDef.removeObject(forKey: "c3")
    userDef.removeObject(forKey: "c4")
    userDef.removeObject(forKey: "c5")
    userDef.removeObject(forKey: "c6")
    userDef.removeObject(forKey: "c7")
    userDef.removeObject(forKey: "c8")
  }
}
