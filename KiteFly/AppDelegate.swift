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
        if !KFUserModel.share.isLogin {
            let tbc = KFTabBarController()
            let nvc = KFNavigationController(rootViewController: tbc)
            self.window?.rootViewController = nvc
        } else {
            let vc  = KFLoginViewController()
            let nvc = KFNavigationController(rootViewController: vc)
            self.window?.rootViewController = nvc
        }
        self.window?.makeKeyAndVisible()
        return true
    }
    
    private func registerModule() {
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
}
