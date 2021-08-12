//
//  KonduktorViewController.swift
//  mud engineer 2
//
//  Created by Pandos on 15.05.2021.
//

import UIKit

class KonduktorViewController: UIViewController {

    @IBOutlet weak var dlinaPredKolonni: UITextField!
    @IBOutlet weak var vnDiametrKolonni: UITextField!

    @IBOutlet weak var dolotoMM: UITextField!
    @IBOutlet weak var kKavernoznosty: UITextField!
    @IBOutlet weak var diametrInstrumenta: UITextField!
    @IBOutlet weak var stenkaInstrumentaMM: UITextField!
    
    @IBOutlet weak var zaboy: UITextField!
    @IBOutlet weak var litrazh: UITextField!
    
    @IBOutlet weak var buttonOutlet: UIButton!
    
    var vKolonni = ""
    var vOtkrtStvol = ""
    var metalSbt = ""
    var vObchii = 0.0
    var vSuchetomTrub = 0.0
    var vRastvoraVtrub = ""
    var vRastvoraZatrub = 0.0
    
    var vihodZaboynoyPachki = 0.0
    var prokachkaDoZaboy = 0.0
    var zhikl = 0.0
    var zhiklPoltora = 0.0
    var zhiklDva = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonOutlet.layer.cornerRadius = 15
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      view.endEditing(true)
    }
    
    @IBAction func raschetButton() {

            guard let litrazhString = litrazh.text,
            let litrazh = Double(litrazhString) else { return }
        
        vKolonni = CalculationManager().vKolonny(
            vnDiametrKolonni: vnDiametrKolonni.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
            dlinaKolonni: dlinaPredKolonni.text?.replacingOccurrences(of: ",", with: ".") ?? "1"
        )
        vOtkrtStvol = CalculationManager().vOtkritiStvol(
            dDolota: dolotoMM.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
            zaboy: zaboy.text?.replacingOccurrences(of: ",", with: ".") ?? "1" ,
            dlinaKolonni: dlinaPredKolonni.text ?? "1",
            kKavernoznosty: kKavernoznosty.text ?? "1"
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
        vihodZaboynoyPachki = Double(vRastvoraZatrub) / ((litrazh * 60) / 1000)
        prokachkaDoZaboy = (Double(vRastvoraVtrub) ?? 1.0) / ((litrazh * 60) / 1000)
        zhikl = vihodZaboynoyPachki + prokachkaDoZaboy
        zhiklPoltora = zhikl * 1.5
        zhiklDva = zhikl * 2

        performSegue(withIdentifier: "qwerty", sender: nil)
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
        
        }
    
}
    

