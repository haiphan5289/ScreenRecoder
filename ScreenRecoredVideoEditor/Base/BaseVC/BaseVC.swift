//
//  BaseVC.swift
//  Beberia
//
//  Created by haiphan on 21/05/2022.
//  Copyright © 2022 IMAC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import EasyBaseCodes

class BaseVC: UIViewController {
    
    enum NavigationHideType {
        case hide, show
    }
    
    let buttonRight: UIButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    var navigationType: NavigationHideType = .show
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            if let navBar = self.navigationController {
                let bar = navBar.navigationBar
                bar.standardAppearance = appearance
                bar.scrollEdgeAppearance = appearance
            }
        }
        self.navigationController?.isNavigationBarHidden = navigationType == .hide
    }
    
    func customRightButton(imgArrow: UIImage){
        buttonRight.setImage(imgArrow, for: .normal)
        buttonRight.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16)
        let leftBarButton = UIBarButtonItem(customView: buttonRight)
        navigationItem.rightBarButtonItem = leftBarButton
    }
    
}
extension UINavigationController {
    func hideHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = true
        }
    }
    func restoreHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = false
        }
    }
    func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
}
