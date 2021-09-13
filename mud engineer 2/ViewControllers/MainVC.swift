//
//  MainVC.swift
//  mud engineer 2
//
//  Created by Pandos on 11.09.2021.
//

import UIKit

enum UserActions: String, CaseIterable {
    case wellFlushing = "Промывка скважины"
    case dilutionFluid = "Разбавление раствора"
    case weighting = "Утяжеление раствора"
    case preferenceVC = "Настройки"
    
}

class MainVC: UICollectionViewController {
    
    let userActions = UserActions.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UserInterfaceStyleManager.shared)
    }
  
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
        let userAction = userActions[indexPath.item]
        cell.userActionCell.text = userAction.rawValue
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .wellFlushing: performSegue(withIdentifier: "wellFlushing", sender: nil)
        case .dilutionFluid: performSegue(withIdentifier: "dilutionFluid", sender: nil)
        case .weighting: performSegue(withIdentifier: "weighting", sender: nil)
        case .preferenceVC: performSegue(withIdentifier: "preferenceVC", sender: nil)
        }
    }
}




