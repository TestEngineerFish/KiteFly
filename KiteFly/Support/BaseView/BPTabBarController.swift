//
//  BPCostomTabBarController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 自定义底部TabBar控制器,实现了TabBar的事件处理协议
open class BPTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let homeVC = KFHomeViewController()
        homeVC.tabBarItem.title         = "首页"
        homeVC.tabBarItem.image         = UIImage(named: "message_unselect")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.selectedImage = UIImage(named: "message_selected")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.imageInsets   = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        homeVC.tabBarItem.isSpringLoaded = true
        
        let taskVC = KFRegisterViewController()
        taskVC.view.backgroundColor = .white
        taskVC.tabBarItem.title         = "动态"
        taskVC.tabBarItem.image         = UIImage(named: "task_unselect")?.withRenderingMode(.alwaysOriginal)
        taskVC.tabBarItem.selectedImage = UIImage(named: "task_selected")?.withRenderingMode(.alwaysOriginal)
        taskVC.tabBarItem.imageInsets   = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        taskVC.tabBarItem.isSpringLoaded = true
        
        let settingVC = BPViewController()
        settingVC.view.backgroundColor = .white
        settingVC.tabBarItem.title         = "设置"
        settingVC.tabBarItem.image         = UIImage(named: "studio_unselect")?.withRenderingMode(.alwaysOriginal)
        settingVC.tabBarItem.selectedImage = UIImage(named: "studio_selected")?.withRenderingMode(.alwaysOriginal)
        settingVC.tabBarItem.imageInsets   = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        settingVC.tabBarItem.isSpringLoaded = true
        
        self.viewControllers = [homeVC, taskVC, settingVC]
        self.updateUI()
        
    }
    
    open func updateUI() {
        self.view.backgroundColor             = .white
        UITabBar.appearance().backgroundImage = UIImage.imageWithColor(.white)
        UITabBar.appearance().isTranslucent   = false
    }
}
