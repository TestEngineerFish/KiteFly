//
//  AppDelegate.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import UIKit
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerModule()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if false {
            let vc = KFLoginViewController()
            let nvc = BPNavigationController(rootViewController: vc)
            self.window?.rootViewController = nvc
        } else {
            self.window?.rootViewController = BPTabBarController()
        }
        self.window?.makeKeyAndVisible()
        return true
    }
    
    private func registerModule() {
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }

}

