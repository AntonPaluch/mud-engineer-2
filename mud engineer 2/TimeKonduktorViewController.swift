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
    @IBOutlet weak var poltoraChiklaLabel: UILabel!
    @IBOutlet weak var dvaChiklaLabel: UILabel!
    
    var litrazh: String?
    var chikl: String?
    var prokachkaDoZaboy: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chiklLabel.text = chikl
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chiklLabel.text = chikl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chiklLabel.text = chikl
    }
}
