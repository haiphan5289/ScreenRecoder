//
//  ManageApp.swift
//  ScreenRecoder
//
//  Created by haiphan on 20/05/2023.
//

import Foundation
import UIKit

final class ManageApp {
    static var shared = ManageApp()
    
    private init() {}
    
    
    func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}
