//
//  AppDelegate.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 28/05/2023.
//

import UIKit
import EasyBaseAudio
import FaceCamFW

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    weak var mainView: ApplicationStateObserver?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ManageApp.shared.launchApp()
        startApp()
        
        moveToTabbar()
        UIFont.overrideInitialize()
        
        return true
    }
    
    private func startApp() {
        ConstantApp.FolderName.allCases.forEach { folder in
            AudioManage.shared.createFolder(path: folder.rawValue, success: nil, failure: nil)
        }
        AudioManage.shared.removeFilesFolder(name: ConstantApp.FolderName.folderRecordFinish.rawValue)
        ConstantApp.shared.removeFilesFolder()
    }

    private func moveToTabbar() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = TabbarVC()
        let navi: UINavigationController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navi
        self.window?.makeKeyAndVisible()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

