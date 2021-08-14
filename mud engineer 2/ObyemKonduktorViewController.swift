//
//  ObyemKonduktorViewController.swift
//  mud engineer 2
//
//  Created by Pandos on 28.07.2021.
//

import UIKit

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
        
        let sYchetom = string(from: sYchetomInstrumentaD ?? 0)
        sYchetomInstrumenta.text = "\(sYchetom) м3"
        let vInstr = string(from: vInstrumenteD ?? 0)
        vInstrumente.text = "\(vInstr) м3"
        let vZatr = string(from: vZatrubeD ?? 0)
        vZatrube.text = "\(vZatr) м3"
        let bezInstr = string(from: vSkvazhineBezInstrumentaD ?? 0)
        vSkvazhineBezInstrumenta.text = "\(bezInstr) м3"
        let metall = string(from: vMetallaD ?? 0)
        vMetalla.text = "\(metall) м3"
        let vKol = string(from: vKolonniD ?? 0)
        vKolonni.text = "\(vKol) м3"
        let vOtkr = string(from: vOtkritiyStvolD ?? 0)
        vOtkritiyStvol.text = "\(vOtkr) м3"
    }
    
    private func string(from number: Double) -> String {
        String(format: "%.1f", number)
    }
    
}
