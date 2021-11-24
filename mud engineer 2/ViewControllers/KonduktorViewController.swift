//
//  KonduktorViewController.swift
//  mud engineer 2
//
//  Created by Pandos on 15.05.2021.
//

import UIKit

class KonduktorViewController: UIViewController {
    
    let userDef = UserDefaults.standard

    @IBOutlet weak var dlinaPredKolonni: UITextField!
    @IBOutlet weak var vnDiametrKolonni: UITextField!
    @IBOutlet weak var dolotoMM: UITextField!
    @IBOutlet weak var kKavernoznosty: UITextField!
    @IBOutlet weak var diametrInstrumenta: UITextField!
    @IBOutlet weak var stenkaInstrumentaMM: UITextField!
    @IBOutlet weak var zaboy: UITextField!
    @IBOutlet weak var litrazh: UITextField!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var resetButtonOutlet: UIButton!
    
    private var vKolonni = ""
    private var vOtkrtStvol = ""
    private var metalSbt = ""
    private var vObchii = 0.0
    private var vSuchetomTrub = 0.0
    private var vRastvoraVtrub = ""
    private var vRastvoraZatrub = 0.0
    private var vihodZaboynoyPachki = 0.0
    private var prokachkaDoZaboy = 0.0
    private var zhikl = 0.0
    private var zhiklPoltora = 0.0
    private var zhiklDva = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UserInterfaceStyleManager.shared)
        buttonOutlet.layer.cornerRadius = 15
        resetButtonOutlet.layer.cornerRadius = resetButtonOutlet.frame.width / 2
        resetButtonOutlet.layer.masksToBounds = true
        presentValue()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      view.endEditing(true)
    }
    
    @IBAction func raschetButton() {
        presentAlert()
        
            guard let litrazhString = litrazh.text,
            let litrazhh = Double(litrazhString) else { return }
        
        vKolonni = CalculationManager().vKolonny(
            vnDiametrKolonni: vnDiametrKolonni.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
            dlinaKolonni: dlinaPredKolonni.text?.replacingOccurrences(of: ",", with: ".") ?? "1"
        )
        vOtkrtStvol = CalculationManager().vOtkritiStvol(
            dDolota: dolotoMM.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
            zaboy: zaboy.text?.replacingOccurrences(of: ",", with: ".") ?? "1" ,
            dlinaKolonni: dlinaPredKolonni.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
            kKavernoznosty: kKavernoznosty.text?.replacingOccurrences(of: ",", with: ".") ?? "1"
        )
        metalSbt = CalculationManager().metalSbt(
            dInstrumenta: diametrInstrumenta.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
            stenkaSbt: stenkaInstrumentaMM.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
            zaboy: zaboy.text?.replacingOccurrences(of: ",", with: ".") ?? "1"
        )
        vObchii = (Double(vKolonni) ?? 1.0) + (Double(vOtkrtStvol) ?? 1.0)
        vSuchetomTrub = vObchii - (Double(metalSbt) ?? 1.0)
        vRastvoraVtrub = CalculationManager().vRastvoraVtrubax(
            dInstrumenta: diametrInstrumenta.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
            stenkaSbt: stenkaInstrumentaMM.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
            zaboy: zaboy.text?.replacingOccurrences(of: ",", with: ".") ?? "1"
        )
        vRastvoraZatrub = vSuchetomTrub - (Double(vRastvoraVtrub) ?? 1.0)
        vihodZaboynoyPachki = Double(vRastvoraZatrub) / ((litrazhh * 60) / 1000)
        prokachkaDoZaboy = (Double(vRastvoraVtrub) ?? 1.0) / ((litrazhh * 60) / 1000)
        zhikl = vihodZaboynoyPachki + prokachkaDoZaboy
        zhiklPoltora = zhikl * 1.5
        zhiklDva = zhikl * 2
        print(zhikl)

        saveValue()
        performSegue(withIdentifier: "qwerty", sender: nil)
        print(vOtkrtStvol)
    }
    
    
    @IBAction func resetButton(_ sender: UIButton) {
        resetValue()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBarController = segue.destination as? UITabBarController else {return}
        let timeVC = tabBarController.viewControllers?.first as! TimeKonduktorViewController
        timeVC.chikl = zhikl
        timeVC.litrazh = litrazh.text
        timeVC.prokachkaDoZaboy = prokachkaDoZaboy
        timeVC.zaboynayaPachka = vihodZaboynoyPachki
        timeVC.poltoraChikla = zhiklPoltora
        timeVC.dvaChikla = zhiklDva
        let obyemVC = tabBarController.viewControllers?.last as! ObyemKonduktorViewController
        obyemVC.sYchetomInstrumentaD = vSuchetomTrub
        obyemVC.vInstrumenteD = Double(vRastvoraVtrub)
        obyemVC.vZatrubeD = vRastvoraZatrub
        obyemVC.vSkvazhineBezInstrumentaD = vObchii
        obyemVC.vMetallaD = Double(metalSbt)
        obyemVC.vKolonniD = Double(vKolonni)
        obyemVC.vOtkritiyStvolD = Double(vOtkrtStvol)
        }
}
    
// MARK: - Alert Controller
extension KonduktorViewController {
    private func showAlert(title: String, message: String? = nil, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = nil
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func presentAlert() {
    guard zaboy.text != "" else {
        showAlert(
        title: NSLocalizedString("bottomWell", comment: "")
    )
    return
    }
    guard dolotoMM.text != "" else {
        showAlert(
        title: NSLocalizedString("bit diameter", comment: "")
    )
    return
    }
    guard kKavernoznosty.text != "" else {
        showAlert(
        title: NSLocalizedString("kCavernosity", comment: "")
    )
    return
    }
    guard diametrInstrumenta.text != "" else {
        showAlert(
        title: NSLocalizedString("dSDP", comment: "")
    )
    return
    }
    guard stenkaInstrumentaMM.text != "" else {
        showAlert(
        title: NSLocalizedString("pipeWall", comment: "")
    )
    return
    }
    guard litrazh.text != "" else {
        showAlert(
        title: NSLocalizedString("liter", comment: "")
    )
    return
    }
    
  }
}
