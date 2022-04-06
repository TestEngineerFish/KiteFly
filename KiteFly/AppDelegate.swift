//
//  AppDelegate.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import UIKit
import IQKeyboardManager
import GrowingCoreKit

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
        Growing.start(withAccountId: "adf93d6f112b32c8")
        Growing.setEnableLog(true)
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if Growing.handle(url) {
            return true
        } else {
            return false
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
}
