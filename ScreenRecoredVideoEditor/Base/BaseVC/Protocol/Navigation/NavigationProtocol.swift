//
//  NavigationProtocol.swift
//  Beberia
//
//  Created by haiphan on 23/08/2022.
//  Copyright © 2022 IMAC. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationProtocol {}
extension NavigationProtocol {
    
    func moveToFaceCame(inputURL: URL) {
        guard let topVC = ManageApp.shared.topViewController() else {
            return
        }
//        let faceCameVc = CheckFaceCamVC.createVC()
//        faceCameVc.videoURL = inputURL
//        let navigation: UINavigationController = UINavigationController(rootViewController: faceCameVc)
////        topVC.navigationController?.pushViewController(faceCameVc)
//        topVC.present(navigation, animated: true)
    }
    
}
