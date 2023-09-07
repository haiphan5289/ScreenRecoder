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
    
    private let userDefault = UserDefaults(suiteName: ConstantApp.appGroupName)
    
    private init() {}
    
    func launchApp() {
        self.userDefault?.set(ConstantApp.UserDefaultType.launchApp.value,
                              forKey: ConstantApp.UserDefaultType.launchApp.key)
    }
    
    func shareProductId(sharedObjects: [URL]) {
        guard let topVC = self.topViewController() else { return }
        let activityVC = UIActivityViewController(activityItems: sharedObjects, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact,
                                            .mail, .message, .postToFacebook, .postToWhatsApp]
        activityVC.popoverPresentationController?.sourceView = topVC.view
        activityVC.title = "PTH"
        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            activityVC.dismiss(animated: true) {
            }
        }
        topVC.present(activityVC, animated: true, completion: nil)
    }
    
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
