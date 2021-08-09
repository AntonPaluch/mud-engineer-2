//
//  ObyemKonduktorViewController.swift
//  mud engineer 2
//
//  Created by Pandos on 28.07.2021.
//

import UIKit

class ObyemKonduktorViewController: UIViewController {

    @IBOutlet weak var primerLabel: UILabel!
    
    var primer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        primerLabel.text = primer

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
