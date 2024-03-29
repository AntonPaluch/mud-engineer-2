//
//  DoubleVC.swift
//  mud engineer 2
//
//  Created by Pandos on 11.09.2021.
//

import UIKit
import YandexMobileMetrica

public let userDef = UserDefaults.standard

class DoubleVC: UICollectionViewController {
    
    let intervalsMassiv = [AllInterval.konduktor.convertString(),
                           AllInterval.kolonna.convertString(),
                           AllInterval.hvost.convertString()
                          ]
    let intervals = AllInterval.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UserInterfaceStyleManager.shared)
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        intervalsMassiv.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! IntervalCell
//        let interval = intervals[indexPath.item]
//        cell.intervalCellOutlet.text = interval.rawValue
        cell.intervalCellOutlet.text = intervalsMassiv[indexPath.item]
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let interval = intervals[indexPath.item]
        switch  interval {
        case .konduktor:
            performSegue(withIdentifier: "konduktor", sender: nil)
            YMMYandexMetrica.reportEvent("Кондуктор")
        case .kolonna:
            performSegue(withIdentifier: "kolonna", sender: nil)
            YMMYandexMetrica.reportEvent("Эксплуатационка")
        case .hvost:
            performSegue(withIdentifier: "hvost", sender: nil)
            YMMYandexMetrica.reportEvent("Хвостовик")
        }
    }
}
