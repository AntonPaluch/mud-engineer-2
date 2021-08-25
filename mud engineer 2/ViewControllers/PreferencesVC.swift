//
//  PreferencesVC.swift
//  mud engineer 2
//
//  Created by Pandos on 22.08.2021.
//

import UIKit

class PreferencesVC: UIViewController {
    
    @IBOutlet weak var switchOutlet: UISwitch!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Set switch status
        switchOutlet.isOn = UserInterfaceStyleManager.shared.currentStyle == .dark
        
        // Start observing style change
        startObserving(&UserInterfaceStyleManager.shared)

    }
    

    @IBAction func switchAction(_ sender: UISwitch) {
        
        let darkModeOn = sender.isOn
        
        // Store in UserDefaults
        UserDefaults.standard.set(darkModeOn, forKey: UserInterfaceStyleManager.userInterfaceStyleDarkModeOn)
        
        // Update interface style
        UserInterfaceStyleManager.shared.updateUserInterfaceStyle(darkModeOn)
        
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
}
