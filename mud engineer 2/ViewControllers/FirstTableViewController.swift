//
//  FirstTableViewController.swift
//  Промывка скважины
//
//  Created by Pandos on 22.03.2021.
//

import UIKit

class FirstTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        startObserving(&UserInterfaceStyleManager.shared)
        
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }


}