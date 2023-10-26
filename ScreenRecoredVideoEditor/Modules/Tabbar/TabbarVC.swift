//
//  TabbarVC.swift
//  ScreenRecoder
//
//  Created by haiphan on 20/05/2023.
//

import UIKit
import EasyBaseAudio

class TabbarVC: UITabBarController {

    enum TabbarType: Int, CaseIterable {
        case home, video, more
        
        var viewController: UIViewController {
            switch self {
            case .home: return HomeVCVC.createVC()
            case .video: return HomeVCVC.createVC()
            case .more: return HomeVCVC.createVC()
            }
        }
        
        var image: UIImage? {
            switch self {
            case .home: return Asset.icHomeCamera.image
            case .video: return Asset.iconVideo.image
            case .more: return Asset.iconMore.image
            }
        }
        
        var text: String {
            switch self {
            case .home:
                return "All Files"
            case .more:
                return "Audio"
            case .video:
                return "Video"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AudioManage.shared.removeFilesFolder(name: ConstantApp.FolderName.folderRecordFinish.rawValue)
        ConstantApp.shared.removeFilesFolder()
    }
}
extension TabbarVC {
    
    private func setupUI() {
//        self.tabBar.isTranslucent = false
//        UITabBar.appearance().tintColor = Asset.appColor.color
//        UITabBar.appearance().barTintColor = Asset.lineColor.color
        //self.view.backgroundColor = Asset.colorApp.color
        if #available(iOS 15.0, *) {
            let appearance: UITabBarAppearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = Asset.lineColor.color
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
        self.viewControllers = TabbarType.allCases.map { $0.viewController }
        self.delegate = self
        
        TabbarType.allCases.forEach { [weak self] type in
            guard let wSelf = self else { return }
            if let vc = wSelf.viewControllers?[type.rawValue] {
                vc.tabBarItem.title = type.text
                vc.tabBarItem.image = type.image
            }
        }
//        DispatchQueue.main.async {
//            self.setupIamge()
//        }
        
    }
    
    private func setupIamge() {
        guard let tabbar = self.tabBar.items?.first,
              let view = tabbar.value(forKey: "view") as? UIView,
              let keyWindow = UIApplication.shared.keyWindow?.rootViewController?.view else  { return }
        
        let frame = view.frame
//        let convetframe = self.view.convert(view.frame, to: <#T##UICoordinateSpace#>)
//        let buttonFrame = self.view.convert(view.frame, from: view.superview)
        let buttonFrame = view.convert(self.tabBar.frame, to: view.superview)
        print("buttonFrame \(buttonFrame)")
        let checkView = UIView(frame: CGRect(origin: CGPoint(x: buttonFrame.width / 2, y: buttonFrame.origin.y - 20), size: CGSize(width: 50, height: 50)))
        checkView.backgroundColor = .red
        self.view.bringSubviewToFront(checkView)
        self.view.addSubview(checkView)
    }
    
}
extension TabbarVC: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}
