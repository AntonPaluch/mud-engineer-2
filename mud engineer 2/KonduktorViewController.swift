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
    @IBOutlet weak var zaboyM: UITextField!
    @IBOutlet weak var dolotoMM: UITextField!
    @IBOutlet weak var kKavernoznosty: UITextField!
    @IBOutlet weak var diametrInstrumenta: UITextField!
    @IBOutlet weak var stenkaInstrumentaMM: UITextField!
    @IBOutlet weak var litrazh: UITextField!
    
    @IBOutlet weak var buttonOutlet: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonOutlet.layer.cornerRadius = 15

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      view.endEditing(true)
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }

    @IBAction func raschetButton(_ sender: UIButton) {
        guard let litrazhString = litrazh.text,
              let litrazh = Double(litrazhString) else {
              return
        }
        
        vKolonni = CalculationManager().vKolonny(
            vnDiametrKolonni: vnDiametrKolonni.text ?? "1",
            dlinaKolonni: dlinaPredKolonni.text ?? "1"
        )
        print("Объем раствора в колонне \(vKolonni)")
        
        vOtkrtStvol = CalculationManager().vOtkritiStvol(
            dDolota: dolotoMM.text ?? "1",
            zaboy: zaboyM.text ?? "1",
            dlinaKolonni: dlinaPredKolonni.text ?? "1",
            kKavernoznosty: kKavernoznosty.text ?? "1"
        )
        print("Объем открытого ствола \(vOtkrtStvol)")
        
        metalSbt = CalculationManager().metalSbt(
            dInstrumenta: diametrInstrumenta.text ?? "1",
            stenkaSbt: stenkaInstrumentaMM.text ?? "1",
            zaboy: zaboyM.text ?? "1"
        )
        print("Объем металла \(metalSbt)")
        
        vObchii = (Double(vKolonni) ?? 1.0) + (Double(vOtkrtStvol) ?? 1.0)
        print("Объем общий \(vObchii)")
        
        vSuchetomTrub = vObchii - (Double(metalSbt) ?? 1.0)
        print("Объем раствора с учетом труб \(vSuchetomTrub)")
        
        vRastvoraVtrub = CalculationManager().vRastvoraVtrubax(
            dInstrumenta: diametrInstrumenta.text ?? "1",
            stenkaSbt: stenkaInstrumentaMM.text ?? "1",
            zaboy: zaboyM.text ?? "1"
        )
        print("Объем раствора в трубах \(vRastvoraVtrub)")
    
        vRastvoraZatrub = vSuchetomTrub - (Double(vRastvoraVtrub) ?? 1.0)
        print("Объем раствора в затрубном пространстве \(vRastvoraZatrub)")
        
        vihodZaboynoyPachki = Double(vRastvoraZatrub) / ((litrazh * 60) / 1000)
        print("Время выхода забойной пачки \(vihodZaboynoyPachki)")
        
        prokachkaDoZaboy = (Double(vRastvoraVtrub) ?? 1.0) / ((litrazh * 60) / 1000)
        print("Прокачка раствора до забоя \(prokachkaDoZaboy)")
        
        zhikl = vihodZaboynoyPachki + prokachkaDoZaboy
        print("Полный цикл \(zhikl)")
    }
    
    
}
