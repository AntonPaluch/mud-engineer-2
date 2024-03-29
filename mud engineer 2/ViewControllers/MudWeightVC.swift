//
//  MudWeightVC.swift
//  mud engineer 2
//
//  Created by Pandos on 13.09.2021.
//

import UIKit

class MudWeightVC: UIViewController {
    
    private var weightComponent = 2.7
    
    @IBOutlet weak var weightFinishSliderOutlet: UISlider!
    @IBOutlet weak var weightFinishLabel: UILabel!
    @IBOutlet weak var volumeOutlet: UISlider!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var weightStartSliderOutlet: UISlider!
    @IBOutlet weak var weightStartLabel: UILabel!
    @IBOutlet weak var weightComponentsOutlet: UIButton!
    @IBOutlet weak var vFinishLabel: UILabel!
    @IBOutlet weak var weightBaritOutlet: UILabel!
    @IBOutlet weak var resultOtletButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UserInterfaceStyleManager.shared)
        weightComponentsOutlet.layer.cornerRadius = 15
        resultOtletButton.layer.cornerRadius = resultOtletButton.frame.width / 2
        setValue(for: weightFinishLabel)
        setValue(for: weightStartLabel)
        volumeLabel.text = String(format: "%.0f", volumeOutlet.value) + String(NSLocalizedString("metr3", comment: ""))
    }
    
    private func setValue(for labels: UILabel...) {
        labels.forEach { label in
            switch label.tag {
            case 0: weightFinishLabel.text = string(from: weightFinishSliderOutlet)
            case 1: weightStartLabel.text = string(from: weightStartSliderOutlet)
            default: break
            }
        }
    }
        
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value) + String(NSLocalizedString("grammSm3", comment: ""))
    }
    
    @IBAction func finishWeightSlider(_ sender: UISlider) {
        weightFinishLabel.text = string(from: sender)
 }
        
    @IBAction func volumeSlider(_ sender: UISlider) {
        volumeLabel.text = String(format: "%.0f", volumeOutlet.value) + String(NSLocalizedString("metr3", comment: ""))
        
    }
    
    @IBAction func startWeightSlider(_ sender: UISlider) {
        weightStartLabel.text = string(from: sender)
    }
    
    
    @IBAction func componentsAction(_ sender: UIButton) {
        showComponents()
    }
    
    @IBAction func resultButton(_ sender: UIButton) {
        if weightFinishSliderOutlet.value < weightStartSliderOutlet.value {
            showAlert(title: NSLocalizedString("inputError", comment: ""), message: NSLocalizedString("weieghtingEror", comment: ""))
        } else {
        weightBaritOutlet.text = resultWeight() + String(NSLocalizedString("kg", comment: ""))
        print(resultWeight())
        }
      
        vFinishLabel.text = volumeFinish() + String(NSLocalizedString("metr3", comment: ""))
    }
    
    func resultWeight() -> String {
        let volume = Double(round(volumeOutlet.value))
        let numberOne = weightComponent * 1000
        let numberTwo = roundOn(value: Double(weightFinishSliderOutlet.value), toNearest: 0.01)
        let numberThree = roundOn(value: Double(weightStartSliderOutlet.value), toNearest: 0.01)
        let delta = numberOne * (numberTwo - numberThree) / (weightComponent - numberTwo) * volume
        return String(Int(delta))
    }
    
    func volumeFinish() -> String {
        let volume = Double(round(volumeOutlet.value))
        let barit = resultWeight()
        let numberOne = weightComponent * 1000
        let Vvolume = Int(volume + ((Double(barit) ?? 1) / numberOne))
        return String(Vvolume)
        
    }
    
    func roundOn( value: Double, toNearest: Double) -> Double {
        return round(value / toNearest) * toNearest
    }
    
}
    
extension MudWeightVC {
    private func showComponents() {
        let pickerViewController = UIViewController()
        pickerViewController.preferredContentSize = CGSize(width: 270.0, height: 130.0)
        let picker = UIPickerView(frame: CGRect(x: 0.0, y: 0.0, width: 270.0, height: 130.0))
        picker.delegate = self
        picker.dataSource = self
        pickerViewController.view.addSubview(picker)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(pickerViewController, forKey: "contentViewController" )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
          self.weightComponentsOutlet.setTitle(WeightComponents.allCases[picker.selectedRow(inComponent: 0)].valueForComponents, for: .normal)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
      }
    }
    
extension MudWeightVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        WeightComponents.allCases.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        WeightComponents.allCases[row].valueForComponents
    }
    
}
    
extension MudWeightVC: UIPickerViewDelegate {
    // Внимательно смотреть на кейсы, чтобы каждый был по одному разу включая ветку default
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch  row {
        case 1: weightComponent = WeightComponents.barit.rawValue
        case 2: weightComponent = WeightComponents.dolomit.rawValue
        case 3: weightComponent = WeightComponents.siderit.rawValue
        default:
            weightComponent = WeightComponents.mramor.rawValue
        }
        print(weightComponent)
    }
}
extension MudWeightVC {
    private func showAlert(title: String, message: String? = nil, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = nil
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}
    

