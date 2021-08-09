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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        buttonOutlet.layer.cornerRadius = 15

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      view.endEditing(true)
    }
    
 


    @IBAction func raschetButton() {
    
    
    
                                               
                guard let litrazhString = litrazh.text,
             let zaboyString = zaboy.text,
//              let dlinaK = dlinaPredKolonni.text?.replacingOccurrences(of: ",", with: "."),
//              let dlinaDouble = Double(dlinaK),
              let zaboy = Double(zaboyString),
              let litrazh = Double(litrazhString) else {
              return
        }
//
//        vKolonni = CalculationManager().vKolonny(
//            vnDiametrKolonni: vnDiametrKolonni.text ?? "1",
//            dlinaKolonni: dlinaPredKolonni.text ?? "1"
//        )
        
        vKolonni = CalculationManager().vKolonny(
            vnDiametrKolonni: vnDiametrKolonni.text?.replacingOccurrences(of: ",", with: ".") ?? "1",
            dlinaKolonni: dlinaPredKolonni.text?.replacingOccurrences(of: ",", with: ".") ?? "1"
        )
        print("Объем раствора в колонне \(vKolonni)")
//        print(dlinaK)
//        print(\(dlinaKolonni)")
        
//        vOtkrtStvol = CalculationManager().vOtkritiStvol(
//            dDolota: dolotoMM.text ?? "1",
//            zaboy: zaboyM.text ?? "1",
//            dlinaKolonni: dlinaPredKolonni.text ?? "1",
//            kKavernoznosty: kKavernoznosty.text ?? "1"
//        )
//        print("Объем открытого ствола \(vOtkrtStvol)")
        
//        metalSbt = CalculationManager().metalSbt(
//            dInstrumenta: diametrInstrumenta.text ?? "1",
//            stenkaSbt: stenkaInstrumentaMM.text ?? "1",
//            zaboy: zaboyM.text ?? "1"
//        )
//        print("Объем металла \(metalSbt)")
//
//        vObchii = (Double(vKolonni) ?? 1.0) + (Double(vOtkrtStvol) ?? 1.0)
//        print("Объем общий \(vObchii)")
//
//        vSuchetomTrub = vObchii - (Double(metalSbt) ?? 1.0)
//        print("Объем раствора с учетом труб \(vSuchetomTrub)")
//
//        vRastvoraVtrub = CalculationManager().vRastvoraVtrubax(
//            dInstrumenta: diametrInstrumenta.text ?? "1",
//            stenkaSbt: stenkaInstrumentaMM.text ?? "1",
//            zaboy: zaboyM.text ?? "1"
//        )
//        print("Объем раствора в трубах \(vRastvoraVtrub)")
//
//        vRastvoraZatrub = vSuchetomTrub - (Double(vRastvoraVtrub) ?? 1.0)
//        print("Объем раствора в затрубном пространстве \(vRastvoraZatrub)")
//
//        vihodZaboynoyPachki = Double(vRastvoraZatrub) / ((litrazh * 60) / 1000)
//        print("Время выхода забойной пачки \(vihodZaboynoyPachki)")
//
//        prokachkaDoZaboy = (Double(vRastvoraVtrub) ?? 1.0) / ((litrazh * 60) / 1000)
//        print("Прокачка раствора до забоя \(prokachkaDoZaboy)")
//
//        zhikl = vihodZaboynoyPachki + prokachkaDoZaboy
        
        zhikl = litrazh + zaboy
        
//        print("Полный цикл \(zhikl)")
        
        
//        dlinaPredKolonni.text = dlinaK
        
//        performSegue(withIdentifier: "konduktorSegue", sender: nil)
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let timeViewController = storyboard.instantiateViewController(identifier: "TimeViewController") as? TimeKonduktorViewController else { return }
        
        
        
//        timeViewController.chikl = String(zhikl)
//        show(timeViewController, sender: nil)
        print(zhikl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBarController = segue.destination as? UITabBarController else {return}
        let timeVC = tabBarController.viewControllers?.first as! TimeKonduktorViewController
        timeVC.chikl = String(zhikl)
      
        }
    
            
}
    
        
//        guard let tabBarController = segue.destination as? UITabBarController else {return}
//        let obyemVC = tabBarController.viewControllers?.last as! ObyemKonduktorViewController
//        let navigationVS = tabBarController.viewControllers?.first as! UINavigationController
//        let timeVC = navigationVS.topViewController as! TimeKonduktorViewController
//        timeVC.litrazh = litrazh.text
        
//        guard let viewControllers = tabBarController.viewControllers else {return}
//        for viewController in viewControllers {
//            if let timeVC = viewController as? TimeKonduktorViewController {
//                timeVC.chikl = String(zhikl)
//                timeVC.prokachkaDoZaboy = String(prokachkaDoZaboy)
//            if let timeVC = viewController as? TimeKonduktorViewController {
//                timeVC.chikl = String(zhikl)
//            }
//            else if let obyemVC = viewController as? ObyemKonduktorViewController {
//                obyemVC.primer = String(zhikl)
//            }
//            else if let obyemVC = viewController as? ObyemKonduktorViewController {
//
//            }
        
       
        
        
        
//        timeVC.chikl = String(zhikl)
//        timeVC.prokachkaDoZaboy = String(prokachkaDoZaboy)
//        obyemVC.primer = String(zhikl)
//    }
    
    

