//
//  BPCostomTabBarController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 自定义底部TabBar控制器,实现了TabBar的事件处理协议
open class KFTabBarController: UITabBarController, UITabBarControllerDelegate {
    
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
        homeVC.tabBarItem.imageInsets   = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        homeVC.tabBarItem.isSpringLoaded = true
        homeVC.tabBarItem.setTitleTextAttributes([.foregroundColor:UIColor.theme], for: .selected)
        
        let taskVC = KFCommunityViewController()
        taskVC.view.backgroundColor     = .white
        taskVC.tabBarItem.title         = "社区"
        taskVC.tabBarItem.image         = UIImage(named: "task_unselect")?.withRenderingMode(.alwaysOriginal)
        taskVC.tabBarItem.selectedImage = UIImage(named: "task_selected")?.withRenderingMode(.alwaysOriginal)
        taskVC.tabBarItem.imageInsets   = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        taskVC.tabBarItem.isSpringLoaded = true
        taskVC.tabBarItem.setTitleTextAttributes([.foregroundColor:UIColor.theme], for: .selected)
        
        let settingVC = KFSettingViewController()
        settingVC.view.backgroundColor  = .white
        settingVC.tabBarItem.title         = "设置"
        settingVC.tabBarItem.image         = UIImage(named: "studio_unselect")?.withRenderingMode(.alwaysOriginal)
        settingVC.tabBarItem.selectedImage = UIImage(named: "studio_selected")?.withRenderingMode(.alwaysOriginal)
        settingVC.tabBarItem.imageInsets   = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        settingVC.tabBarItem.isSpringLoaded = true
        settingVC.tabBarItem.setTitleTextAttributes([.foregroundColor:UIColor.theme], for: .selected)
        
        self.viewControllers = [homeVC, taskVC, settingVC]
        self.updateUI()
        self.selectedIndex = 0
    }
    
    open func updateUI() {
        self.view.backgroundColor             = .white
        UITabBar.appearance().backgroundImage = UIImage.imageWithColor(.white)
        UITabBar.appearance().isTranslucent   = false
    }
}
