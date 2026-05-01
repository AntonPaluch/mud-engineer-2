//
//  ProductColumnVC.swift
//  mud engineer 2
//
//  Created by Pandos on 14.08.2021.
//

import UIKit
import YandexMobileMetrica

class ProductColumnVC: UIViewController {
        
    @IBOutlet weak var longColumn: UITextField!
    @IBOutlet weak var inDiametrColumn: UITextField!
    @IBOutlet weak var wellBottom: UITextField!
    @IBOutlet weak var diametrDrilling: UITextField!
    @IBOutlet weak var kCavernosity: UITextField!
    @IBOutlet weak var diametrDrillingPipes: UITextField!
    @IBOutlet weak var wallThickness: UITextField!
    @IBOutlet weak var pumpLiters: UITextField!
    @IBOutlet weak var resultButtonOutlet: UIButton!
    @IBOutlet weak var resetButtonOutlet: UIButton!
    
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
        resetButtonOutlet.layer.cornerRadius = resetButtonOutlet.frame.width / 2
        resetButtonOutlet.layer.masksToBounds = true
        presentValue()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      view.endEditing(true)
    }
    
    @IBAction func resultButton(_ sender: Any) {
        guard validateInput() else { return }
        allResult()
        saveValue()
        
        YMMYandexMetrica.reportEvent("Скважина_Эксплуатационка_внДиаметрКолонны_\(inDiametrColumn.text ?? "0")")
        YMMYandexMetrica.reportEvent("Скважина_Эксплуатационка_длинаПредКолонны_\(longColumn.text ?? "0")")
        YMMYandexMetrica.reportEvent("Расчет - Эксплуатационка")
        performSegue(withIdentifier: "column", sender: nil)
    }
    
    
    @IBAction func resetButton(_ sender: UIButton) {
        YMMYandexMetrica.reportEvent("Reset - Эксплуатационка")
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
extension ProductColumnVC {
    private func showAlert(title: String, message: String? = nil, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = nil
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func validateInput() -> Bool {
        guard isPositiveNumber(wellBottom.text) else {
            showAlert(title: NSLocalizedString("bottomWell", comment: ""))
            return false
        }
        guard isPositiveNumber(diametrDrilling.text) else {
            showAlert(title: NSLocalizedString("bit diameter", comment: ""))
            return false
        }
        guard isPositiveNumber(kCavernosity.text) else {
            showAlert(title: NSLocalizedString("kCavernosity", comment: ""))
            return false
        }
        guard isPositiveNumber(diametrDrillingPipes.text) else {
            showAlert(title: NSLocalizedString("dSDP", comment: ""))
            return false
        }
        guard isPositiveNumber(wallThickness.text) else {
            showAlert(title: NSLocalizedString("pipeWall", comment: ""))
            return false
        }
        guard isPositiveNumber(pumpLiters.text) else {
            showAlert(title: NSLocalizedString("liter", comment: ""))
            return false
        }
        return true
    }

    private func isPositiveNumber(_ text: String?) -> Bool {
        guard let text = text?.replacingOccurrences(of: ",", with: "."),
              let value = Double(text),
              value.isFinite else { return false }
        return value > 0
    }
}

// MARK: - allResult

extension ProductColumnVC {
    func allResult() {
    guard let pumpLitersString = pumpLiters.text?.replacingOccurrences(of: ",", with: "."),
          let pumpLitersDouble = Double(pumpLitersString),
          pumpLitersDouble > 0 else { return }

    volumeColumn = CalculationManager().vKolonny(
    vnDiametrKolonni: inDiametrColumn.text?.replacingOccurrences(of: ",", with: ".") ?? "0",
    dlinaKolonni: longColumn.text?.replacingOccurrences(of: ",", with: ".") ?? "0"
)
    volumeOpenBorehole = CalculationManager().vOtkritiStvol(
    dDolota: diametrDrilling.text?.replacingOccurrences(of: ",", with: ".") ?? "0",
    zaboy: wellBottom.text?.replacingOccurrences(of: ",", with: ".") ?? "0" ,
    dlinaKolonni: longColumn.text?.replacingOccurrences(of: ",", with: ".") ?? "0",
    kKavernoznosty: kCavernosity.text?.replacingOccurrences(of: ",", with: ".") ?? "1"
)
    volumePipe = CalculationManager().metalSbt(
    dInstrumenta: diametrDrillingPipes.text?.replacingOccurrences(of: ",", with: ".") ?? "0",
    stenkaSbt: wallThickness.text?.replacingOccurrences(of: ",", with: ".") ?? "0",
    zaboy: wellBottom.text?.replacingOccurrences(of: ",", with: ".") ?? "0"
)
    volumeTotal = (Double(volumeColumn) ?? 0) + (Double(volumeOpenBorehole) ?? 0)
    volumeincludingPipes = max(volumeTotal - (Double(volumePipe) ?? 0), 0)
    volumeInPipes = CalculationManager().vRastvoraVtrubax(
    dInstrumenta: diametrDrillingPipes.text?.replacingOccurrences(of: ",", with: ".") ?? "0",
    stenkaSbt: wallThickness.text?.replacingOccurrences(of: ",", with: ".") ?? "0",
    zaboy: wellBottom.text?.replacingOccurrences(of: ",", with: ".") ?? "0"
)
    volumeBehindPipes = max(volumeincludingPipes - (Double(volumeInPipes) ?? 0), 0)
    outputDownholePack = Double(volumeBehindPipes) / ((pumpLitersDouble * 60) / 1000)
    pumpingToBottomWell = (Double(volumeInPipes) ?? 0) / ((pumpLitersDouble * 60) / 1000)
    wellFlushingCycle = outputDownholePack + pumpingToBottomWell
    wellFlushingCycleOneHalf = wellFlushingCycle * 1.5
    wellFlushingCycleTwo = wellFlushingCycle * 2
    }
}
