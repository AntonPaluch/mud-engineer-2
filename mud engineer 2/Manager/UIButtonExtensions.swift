//
//  UIButtonExtensions.swift
//  mud engineer 2
//
//  Created by Pandos on 07.09.2021.
//

import UIKit

extension UIButton {

  func pulsate() {
    
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.4
    pulse.fromValue = 0.98
    pulse.toValue = 1.0
    pulse.autoreverses = true
    pulse.repeatCount = .infinity
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    layer.add(pulse, forKey: nil)

  }

}
