//
//  DilutionVC.swift
//  mud engineer 2
//
//  Created by Pandos on 14.09.2021.
//

import UIKit

class DilutionVC: UIViewController {
    
    @IBOutlet weak var addVolumeLabel: UILabel!
    @IBOutlet weak var addVolumeSliderOutlet: UISlider!
    
    @IBOutlet weak var addWeightMudLabel: UILabel!
    @IBOutlet weak var addWeightMudSliderOutlet: UISlider!
    
    @IBOutlet weak var startVolumeSliderOutlet: UISlider!
    @IBOutlet weak var startVolumeLabelOutlet: UILabel!
    
    @IBOutlet weak var startWightSlider: UISlider!
    @IBOutlet weak var startWeightLabel: UILabel!
    
    @IBOutlet weak var resultOutlet: UIButton!
    
    @IBOutlet weak var finishLabel: UILabel!
    @IBOutlet weak var weightFinishLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UserInterfaceStyleManager.shared)
        resultOutlet.layer.cornerRadius = resultOutlet.frame.width / 2
        //Методы отвечают чтобы при загрузке экрана значения лейбла соответствовали значениям на слайдере
        addVolumeLabel.text = String(format: "%.0f", addVolumeSliderOutlet.value) + String(NSLocalizedString("metr3", comment: ""))
        addWeightMudLabel.text = String(format: "%.2f", addWeightMudSliderOutlet.value) + String(NSLocalizedString("grammSm3", comment: ""))
        startVolumeLabelOutlet.text = String(format: "%.0f", startVolumeSliderOutlet.value) + String(NSLocalizedString("metr3", comment: ""))
        startWeightLabel.text = String(format: "%.2f", startWightSlider.value) + String(NSLocalizedString("grammSm3", comment: ""))
 
    }
    
    @IBAction func addVolumeSliderAction(_ sender: UISlider) {
        addVolumeLabel.text = String(format: "%.0f", addVolumeSliderOutlet.value) + String(NSLocalizedString("metr3", comment: ""))
    }
    
    @IBAction func weightAddSliderAction(_ sender: UISlider) {
        addWeightMudLabel.text = String(format: "%.2f", addWeightMudSliderOutlet.value) + String(NSLocalizedString("grammSm3", comment: ""))
    }
    
    
    @IBAction func startVolumeSliderAction(_ sender: UISlider) {
        startVolumeLabelOutlet.text = String(format: "%.0f", startVolumeSliderOutlet.value) + String(NSLocalizedString("metr3", comment: ""))
    }
    
    @IBAction func weightStartSliderAction(_ sender: UISlider) {
        startWeightLabel.text = String(format: "%.2f", startWightSlider.value) + String(NSLocalizedString("grammSm3", comment: ""))
    }
    
    @IBAction func resultButton(_ sender: UIButton) {
        weightFinishLabel.text = String(dilutionWeight()) + String(NSLocalizedString("grammSm3", comment: ""))
        finishLabel.text = String(allMud()) + String(NSLocalizedString("metr3", comment: ""))
    }
    
    func dilutionWeight() -> String {
        let volumeAdd = Double(round(addVolumeSliderOutlet.value))
        let pAdd = roundOn(value: Double(addWeightMudSliderOutlet.value), toNearest: 0.01)
        let volumeStart = Double(round(startVolumeSliderOutlet.value))
        let pStart = roundOn(value: Double(startWightSlider.value), toNearest: 0.01)
        let allMud = volumeAdd + volumeStart
        let result = ((volumeStart * pStart) + (volumeAdd * pAdd)) / allMud
        return String(format: "%.3f", result)
    }
    
    func allMud() -> String {
        let oneNumber = round(addVolumeSliderOutlet.value)
        let twoNumber = round(startVolumeSliderOutlet.value)
        let all = oneNumber + twoNumber
        return String(format: "%.0f", all)
    }
    
    func roundOn( value: Double, toNearest: Double) -> Double {
        return round(value / toNearest) * toNearest
    }
    
    
}

