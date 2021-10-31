//
//  PreferencesVC.swift
//  mud engineer 2
//
//  Created by Pandos on 22.08.2021.
//

import UIKit

class PreferencesVC: UIViewController {
    
    @IBOutlet weak var stackViewOutlet: UIStackView!
    
    @IBOutlet weak var buttonOutlet: UIButton!
    
    @IBOutlet weak var switchOutlet: UISwitch!
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        return view
    } ()
   
    private func pinBacground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinBacground(backgroundView, to: stackViewOutlet)
        buttonOutlet.layer.cornerRadius = 10
        
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
    
    @IBAction func donatButtonAction(_ sender: UIButton) {
        
        sender.pulsate()
    }
    
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }

        

}


