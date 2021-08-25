//
//  KonduktorViewController.swift
//  mud engineer 2
//
//  Created by Pandos on 15.05.2021.
//

import UIKit

class KonduktorViewController: UIViewController {
    
    private let userDef = UserDefaults.standard

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
        
        dlinaPredKolonni.text = userDef.string(forKey: "k1")
        vnDiametrKolonni.text = userDef.string(forKey: "k2")
        dolotoMM.text = userDef.string(forKey: "k3")
        kKavernoznosty.text = userDef.string(forKey: "k4")
        diametrInstrumenta.text = userDef.string(forKey: "k5")
        stenkaInstrumentaMM.text = userDef.string(forKey: "k6")
        zaboy.text = userDef.string(forKey: "k7")
        litrazh.text = userDef.string(forKey: "k8")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      view.endEditing(true)
    }
    
    @IBAction func raschetButton() {
        
        guard zaboy.text != "" else {
            showAlert(
            title: "Введите забой скважины"
        )
        return
            
        }
        
        guard dolotoMM.text != "" else {
            showAlert(
            title: "Введите диаметр долота"
        )
        return
        }
        
        guard kKavernoznosty.text != "" else {
            showAlert(
            title: "Введите коэффициент кавернозности"
        )
        return
        }
        
        guard diametrInstrumenta.text != "" else {
            showAlert(
            title: "Введите диаметр инструмента"
        )
        return
        }
        guard stenkaInstrumentaMM.text != "" else {
            showAlert(
            title: "Введите толщину стенки инструмента"
        )
        return
        }
        guard litrazh.text != "" else {
            showAlert(
            title: "Введите литраж"
        )
        return
        }
        
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

        userDef.setValue(dlinaPredKolonni.text, forKey: "k1")
        userDef.setValue(vnDiametrKolonni.text, forKey: "k2")
        userDef.setValue(dolotoMM.text, forKey: "k3")
        userDef.setValue(kKavernoznosty.text, forKey: "k4")
        userDef.setValue(diametrInstrumenta.text, forKey: "k5")
        userDef.setValue(stenkaInstrumentaMM.text, forKey: "k6")
        userDef.setValue(zaboy.text, forKey: "k7")
        userDef.setValue(litrazh.text, forKey: "k8")
        
        performSegue(withIdentifier: "qwerty", sender: nil)
        print(vOtkrtStvol)
    }
    
    
    @IBAction func resetButton(_ sender: UIButton) {
        
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
}
