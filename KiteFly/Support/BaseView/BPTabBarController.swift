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
        let messageVC = BPViewController()
        messageVC.tabBarItem.title         = "首页"
        messageVC.tabBarItem.image         = UIImage(named: "message_unselect")?.withRenderingMode(.alwaysOriginal)
        messageVC.tabBarItem.selectedImage = UIImage(named: "message_selected")?.withRenderingMode(.alwaysOriginal)
        messageVC.tabBarItem.imageInsets   = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        messageVC.tabBarItem.isSpringLoaded = true
        
        let taskVC = BPViewController()
        taskVC.view.backgroundColor = .white
        taskVC.tabBarItem.title         = "动态"
        taskVC.tabBarItem.image         = UIImage(named: "task_unselect")?.withRenderingMode(.alwaysOriginal)
        taskVC.tabBarItem.selectedImage = UIImage(named: "task_selected")?.withRenderingMode(.alwaysOriginal)
        taskVC.tabBarItem.imageInsets   = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        taskVC.tabBarItem.isSpringLoaded = true
        
        let studioVC = BPViewController()
        studioVC.view.backgroundColor = .white
        studioVC.tabBarItem.title         = "设置"
        studioVC.tabBarItem.image         = UIImage(named: "studio_unselect")?.withRenderingMode(.alwaysOriginal)
        studioVC.tabBarItem.selectedImage = UIImage(named: "studio_selected")?.withRenderingMode(.alwaysOriginal)
        studioVC.tabBarItem.imageInsets   = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        studioVC.tabBarItem.isSpringLoaded = true
        
        self.viewControllers = []
        self.updateUI()
        
    }
    
    open func updateUI() {
        UITabBar.appearance().backgroundImage         = UIImage.imageWithColor(.white)
        UITabBar.appearance().isTranslucent           = false
    }
}
