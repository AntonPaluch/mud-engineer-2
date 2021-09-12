//
//  DoubleVC.swift
//  mud engineer 2
//
//  Created by Pandos on 11.09.2021.
//

import UIKit

enum AllInterval: String, CaseIterable {
    case konduktor = "Кондуктор"
    case kolonna = "Эксплуатационная колонна"
    case hvost = "Хвостовик"
}

class DoubleVC: UICollectionViewController {
    
    let intervals = AllInterval.allCases

    override func viewDidLoad() {
        super.viewDidLoad()

       
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell2")

        
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        intervals.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! IntervalCell
        let interval = intervals[indexPath.item]
        cell.intervalCellOutlet.text = interval.rawValue
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
