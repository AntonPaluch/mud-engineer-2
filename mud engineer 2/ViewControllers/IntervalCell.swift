//
//  IntervalCell.swift
//  mud engineer 2
//
//  Created by Pandos on 11.09.2021.
//

import UIKit

class IntervalCell: UICollectionViewCell {
    
    @IBOutlet weak var intervalCellOutlet: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 15
    }
}
