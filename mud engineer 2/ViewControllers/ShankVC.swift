//
//  ShankVC.swift
//  mud engineer 2
//
//  Created by Pandos on 17.08.2021.
//

import UIKit
import YandexMobileMetrica

class ShankVC: UIViewController {
        
    @IBOutlet weak var longColumn: UITextField!
    @IBOutlet weak var inDiametrColumn: UITextField!
    @IBOutlet weak var wellBottom: UITextField!
    @IBOutlet weak var diametrDrilling: UITextField!
    @IBOutlet weak var kCavernosity: UITextField!
    @IBOutlet weak var diametrDrillingPipes: UITextField!
    @IBOutlet weak var wallThickness: UITextField!
    @IBOutlet weak var pumpLiters: UITextField!
    @IBOutlet weak var resultButtonOutlet: UIButton!
    @IBOutlet weak var resetOutlet: UIButton!
    
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
        startObserving(&UserInterfaceStyleManager.shared)
        resultButtonOutlet.layer.cornerRadius = 15
        resetOutlet.layer.cornerRadius = resetOutlet.frame.width / 2
        resetOutlet.layer.masksToBounds = true
        presentValue()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      view.endEditing(true)
    }
   
    @IBAction func resultButton(_ sender: UIButton) {
        presentAlert()
        allResult()
        saveValue()
        
        YMMYandexMetrica.reportEvent("Скважина_Хвостовик_внДиаметрКолонны_\(inDiametrColumn.text ?? "0")")
        YMMYandexMetrica.reportEvent("Скважина_Хвостовик_длинаПредКолонны_\(longColumn.text ?? "0")")
        YMMYandexMetrica.reportEvent("Расчет - хвостовик")
        performSegue(withIdentifier: "shank", sender: nil)
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        YMMYandexMetrica.reportEvent("Reset - Хвостовик")
        resetValue()
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

// MARK: - Alert Controller
extension ShankVC {
    private func showAlert(title: String, message: String? = nil, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func presentAlert() {
        guard wellBottom.text != "" else {showAlert(title: NSLocalizedString("bottomWell", comment: ""))
           return }
        guard diametrDrilling.text != "" else {showAlert(title: NSLocalizedString("bit diameter", comment: ""))
           return }
        guard kCavernosity.text != "" else {showAlert(title: NSLocalizedString("kCavernosity", comment: ""))
           return }
        guard diametrDrillingPipes.text != "" else {showAlert(title: NSLocalizedString("dSDP", comment: ""))
           return }
        guard wallThickness.text != "" else {showAlert(title: NSLocalizedString("pipeWall", comment: ""))
           return }
        guard pumpLiters.text != "" else {showAlert(title: NSLocalizedString("liter", comment: ""))
           return}
    }
}

// MARK: - allResult

extension ShankVC {
    func allResult() {
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
  }
}
