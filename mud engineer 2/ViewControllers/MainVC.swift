//
//  MainVC.swift
//  mud engineer 2
//
//  Created by Pandos on 11.09.2021.
//

import UIKit

enum UserActions: String, CaseIterable {
    case wellFlushing
    case dilutionFluid
    case weighting
    case preferenceVC
    
//    func localizedString() -> String {
//        return NSLocalizedString(self.rawValue, comment: "")
//    }
    
    func labelEnum() -> String {
        switch self {
        case .wellFlushing:
            return NSLocalizedString("wellFlushing", comment: "")
        case .dilutionFluid:
            return NSLocalizedString("dilutionFluid", comment: "")
        case .weighting:
            return NSLocalizedString("weighting", comment: "")
        case .preferenceVC:
            return NSLocalizedString("preferenceVC", comment: "")
        }
    }
}

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
        case .wellFlushing: performSegue(withIdentifier: "wellFlushing", sender: nil)
        case .dilutionFluid: performSegue(withIdentifier: "dilutionFluid", sender: nil)
        case .weighting: performSegue(withIdentifier: "weighting", sender: nil)
        case .preferenceVC: performSegue(withIdentifier: "preferenceVC", sender: nil)
        }
    }
}




