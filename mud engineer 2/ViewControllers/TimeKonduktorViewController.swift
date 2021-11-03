//
//  TimeKonduktorViewController.swift
//  mud engineer 2
//
//  Created by Pandos on 22.07.2021.
//

import UIKit

class TimeKonduktorViewController: UIViewController {
    
    @IBOutlet weak var litrazhLabel: UILabel!
    @IBOutlet weak var chiklLabel: UILabel!
    @IBOutlet weak var prokachkaDoZaboyLabel: UILabel!
    @IBOutlet weak var zaboynayaPachkaLabel: UILabel!
    @IBOutlet weak var poltoraChiklaLabel: UILabel!
    @IBOutlet weak var dvaChiklaLabel: UILabel!
    
    var litrazh: String?
    var chikl: Double?
    var prokachkaDoZaboy: Double?
    var zaboynayaPachka: Double?
    var poltoraChikla: Double?
    var dvaChikla: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UserInterfaceStyleManager.shared)
        let chiklRound = string(from: chikl ?? 0)
        chiklLabel.text = chiklRound + String(NSLocalizedString("minutes", comment: ""))
//        litrazhLabel.text = "\(litrazh ?? "0") л/с"
        litrazhLabel.text = "\(litrazh ?? "0")" + String(NSLocalizedString("lps", comment: ""))
        let prokachka = string(from: prokachkaDoZaboy ?? 0)
        prokachkaDoZaboyLabel.text = prokachka + String(NSLocalizedString("minutes", comment: ""))
        let vihodPachki = string(from: zaboynayaPachka ?? 0)
        zaboynayaPachkaLabel.text = vihodPachki + String(NSLocalizedString("minutes", comment: ""))
        poltoraChiklaLabel.text = converterTime(time: poltoraChikla ?? 0)
        dvaChiklaLabel.text = converterTime(time: dvaChikla ?? 0)
        
        guard litrazhLabel.text != "0 lps", litrazhLabel.text != "0 л/с" else {
            chiklLabel.text = NSLocalizedString("notFlushed", comment: "")
            prokachkaDoZaboyLabel.text = " - "
            zaboynayaPachkaLabel.text = " - "
            poltoraChiklaLabel.text = " - "
            dvaChiklaLabel.text = " - "
            return
        }
        
    }
    
    private func string(from number: Double) -> String {
        String(format: "%.2f", number)
    }
    
    private func converterTime(time: Double ) -> String {
        let num = time
        let hours = (num / 60)
        let rhours = floor(hours)
        let minutes = (hours - rhours) * 60
        let rminutes = round(minutes)
        let rhoursStr = String(format: "%.0f", rhours)
        let rminutesStr = String(format: "%.0f", rminutes)
        return rhoursStr + String(NSLocalizedString("h", comment: "")) + " " + rminutesStr + String(NSLocalizedString("min", comment: ""))
    }
}
