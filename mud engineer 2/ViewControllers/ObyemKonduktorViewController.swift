//
//  ObyemKonduktorViewController.swift
//  mud engineer 2
//
//  Created by Pandos on 28.07.2021.
//

import UIKit
import YandexMobileMetrica

class ObyemKonduktorViewController: UIViewController {

    @IBOutlet weak var sYchetomInstrumenta: UILabel!
    @IBOutlet weak var vInstrumente: UILabel!
    @IBOutlet weak var vZatrube: UILabel!
    @IBOutlet weak var vSkvazhineBezInstrumenta: UILabel!
    @IBOutlet weak var vMetalla: UILabel!
    @IBOutlet weak var vKolonni: UILabel!
    @IBOutlet weak var vOtkritiyStvol: UILabel!
    
    var sYchetomInstrumentaD: Double?
    var vInstrumenteD: Double?
    var vZatrubeD: Double?
    var vSkvazhineBezInstrumentaD: Double?
    var vMetallaD: Double?
    var vKolonniD: Double?
    var vOtkritiyStvolD: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YMMYandexMetrica.reportEvent("Открыли объемы")
        
        startObserving(&UserInterfaceStyleManager.shared)
        
        let sYchetom = string(from: sYchetomInstrumentaD ?? 0)
        sYchetomInstrumenta.text = sYchetom + String(NSLocalizedString("metr3", comment: ""))
        let vInstr = string(from: vInstrumenteD ?? 0)
        vInstrumente.text = vInstr + String(NSLocalizedString("metr3", comment: ""))
        let vZatr = string(from: vZatrubeD ?? 0)
        vZatrube.text = vZatr + String(NSLocalizedString("metr3", comment: ""))
        let bezInstr = string(from: vSkvazhineBezInstrumentaD ?? 0)
        vSkvazhineBezInstrumenta.text = bezInstr + String(NSLocalizedString("metr3", comment: ""))
        let metall = string(from: vMetallaD ?? 0)
        vMetalla.text = metall + String(NSLocalizedString("metr3", comment: ""))
        let vKol = string(from: vKolonniD ?? 0)
        vKolonni.text = vKol + String(NSLocalizedString("metr3", comment: ""))
        let vOtkr = string(from: vOtkritiyStvolD ?? 0)
        vOtkritiyStvol.text = vOtkr + String(NSLocalizedString("metr3", comment: ""))
    }
    
    private func string(from number: Double) -> String {
        String(format: "%.1f", number)
    }
    
}

