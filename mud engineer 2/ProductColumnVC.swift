//
//  ProductColumnVC.swift
//  mud engineer 2
//
//  Created by Pandos on 14.08.2021.
//

import UIKit

class ProductColumnVC: UIViewController {
    
    private let userDef = UserDefaults.standard
    
    @IBOutlet weak var longColumn: UITextField!
    @IBOutlet weak var inDiametrColumn: UITextField!
    @IBOutlet weak var wellBottom: UITextField!
    @IBOutlet weak var diametrDrilling: UITextField!
    @IBOutlet weak var kCavernosity: UITextField!
    @IBOutlet weak var diametrDrillingPipes: UITextField!
    @IBOutlet weak var wallThickness: UITextField!
    @IBOutlet weak var pumpLiters: UITextField!
    @IBOutlet weak var resultButtonOutlet: UIButton!
    
    private var volumeColumn = ""
    private var volumeOpenBorehole = ""
    private var volumePipe = ""
    private var volumeTotal = 0.0
    private var volumeincludingPipes = 0.0
    private var volumeInPipes = ""
    private var volumeBehindPipes = 0.0
    private var outputDownholePack = 0.0
    private var pumpingToBottomWell = 0.0
    private var wellFlushingCycle = 0.0
    private var wellFlushingCycleOneHalf = 0.0
    private var wellFlushingCycleTwo = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultButtonOutlet.layer.cornerRadius = 15
        longColumn.text = userDef.string(forKey: "c1")
        inDiametrColumn.text = userDef.string(forKey: "c2")
        wellBottom.text = userDef.string(forKey: "c3")
        diametrDrilling.text = userDef.string(forKey: "c4")
        kCavernosity.text = userDef.string(forKey: "c5")
        diametrDrillingPipes.text = userDef.string(forKey: "c6")
        wallThickness.text = userDef.string(forKey: "c7")
        pumpLiters.text = userDef.string(forKey: "c8")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      view.endEditing(true)
    }
    
    @IBAction func resultButton(_ sender: Any) {
        
        guard let pumpLitersString = pumpLiters.text,
        let pumpLitersDouble = Double(pumpLitersString) else { return }
    
        volumeColumn = CalculationManager().vKolonny(
        vnDiametrKolonni: inDiametrColumn.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
        dlinaKolonni: longColumn.text?.replacingOccurrences(of: ",", with: ".") ?? "1"
    )
        volumeOpenBorehole = CalculationManager().vOtkritiStvol(
        dDolota: diametrDrilling.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
        zaboy: wellBottom.text?.replacingOccurrences(of: ",", with: ".") ?? "1" ,
        dlinaKolonni: longColumn.text ?? "1",
        kKavernoznosty: kCavernosity.text ?? "1"
    )
        volumePipe = CalculationManager().metalSbt(
        dInstrumenta: diametrDrillingPipes.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
        stenkaSbt: wallThickness.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
        zaboy: wellBottom.text?.replacingOccurrences(of: ",", with: ".") ?? "1"
    )
        volumeTotal = (Double(volumeColumn) ?? 1.0) + (Double(volumeOpenBorehole) ?? 1.0)
        volumeincludingPipes = volumeTotal - (Double(volumePipe) ?? 1.0)
        volumeInPipes = CalculationManager().vRastvoraVtrubax(
        dInstrumenta: diametrDrillingPipes.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
        stenkaSbt: wallThickness.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
        zaboy: wellBottom.text?.replacingOccurrences(of: ",", with: ".") ?? "1"
    )
        volumeBehindPipes = volumeincludingPipes - (Double(volumeInPipes) ?? 1.0)
        outputDownholePack = Double(volumeincludingPipes) / ((pumpLitersDouble * 60) / 1000)
        pumpingToBottomWell = (Double(volumeInPipes) ?? 1.0) / ((pumpLitersDouble * 60) / 1000)
        wellFlushingCycle = outputDownholePack + pumpingToBottomWell
        wellFlushingCycleOneHalf = wellFlushingCycle * 1.5
        wellFlushingCycleTwo = wellFlushingCycle * 2
        
        userDef.setValue(longColumn.text, forKey: "c1")
        userDef.setValue(inDiametrColumn.text, forKey: "c2")
        userDef.setValue(wellBottom.text, forKey: "c3")
        userDef.setValue(diametrDrilling.text, forKey: "c4")
        userDef.setValue(kCavernosity.text, forKey: "c5")
        userDef.setValue(diametrDrillingPipes.text, forKey: "c6")
        userDef.setValue(wallThickness.text, forKey: "c7")
        userDef.setValue(pumpLiters.text, forKey: "c8")
        
        performSegue(withIdentifier: "column", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBarController = segue.destination as? UITabBarController else {return}
        let timeVC = tabBarController.viewControllers?.first as! TimeKonduktorViewController
        timeVC.chikl = wellFlushingCycle
        timeVC.litrazh = pumpLiters.text
        timeVC.prokachkaDoZaboy = pumpingToBottomWell
        timeVC.zaboynayaPachka = outputDownholePack
        timeVC.poltoraChikla = wellFlushingCycleOneHalf
        timeVC.dvaChikla = wellFlushingCycleTwo
        let obyemVC = tabBarController.viewControllers?.last as! ObyemKonduktorViewController
        obyemVC.sYchetomInstrumentaD = volumeincludingPipes
        obyemVC.vInstrumenteD = Double(volumeInPipes)
        obyemVC.vZatrubeD = volumeBehindPipes
        obyemVC.vSkvazhineBezInstrumentaD = volumeTotal
        obyemVC.vMetallaD = Double(volumePipe)
        obyemVC.vKolonniD = Double(volumeColumn)
        obyemVC.vOtkritiyStvolD = Double(volumeOpenBorehole)
    }
}
