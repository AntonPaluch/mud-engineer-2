//
//  UIViewExtensions.swift
//  mud engineer 2
//
//  Created by Pandos on 04.09.2021.
//

import UIKit

public extension UIView {
     func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
