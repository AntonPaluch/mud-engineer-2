//
//  MainVC.swift
//  mud engineer 2
//
//  Created by Pandos on 11.09.2021.
//

import UIKit
import YandexMobileMetrica

class MainVC: UICollectionViewController {
    
    let user = [UserActions.wellFlushing.labelEnum(),
                UserActions.dilutionFluid.labelEnum(),
                UserActions.weighting.labelEnum(),
                UserActions.preferenceVC.labelEnum(),
    ]

    let userActions = UserActions.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UserInterfaceStyleManager.shared)
    }
  
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        user.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
//        let userAction = userActions[indexPath.item]
//        let userAction = user[indexPath.item]
//        cell.userActionCell.text = userAction.rawValue
        cell.userActionCell.text = user[indexPath.item]
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .wellFlushing:
            performSegue(withIdentifier: "wellFlushing", sender: nil)
            YMMYandexMetrica.reportEvent("Промыка скважины")
        case .dilutionFluid:
            performSegue(withIdentifier: "dilutionFluid", sender: nil)
            YMMYandexMetrica.reportEvent("Разбавление раствора")
        case .weighting:
            performSegue(withIdentifier: "weighting", sender: nil)
            YMMYandexMetrica.reportEvent("Утяжеление")
        case .preferenceVC:
            performSegue(withIdentifier: "preferenceVC", sender: nil)
            YMMYandexMetrica.reportEvent("Настройки")
        }
    }
}


