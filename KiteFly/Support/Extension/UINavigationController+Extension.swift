//
//  UINavigationController+Extension.swift
//  MessageCenter
//
//  Created by apple on 2021/10/28.
//  Copyright © 2021 KLC. All rights reserved.
//

import UIKit

public extension UINavigationController {
    
    func containClass(with targetClass: AnyClass) -> Bool {
        
        var isContain = false
        for otherClass in self.children {
            if otherClass.classForCoder == targetClass {
                isContain = true
                break
            }
        }
        return isContain
    }
    
    func push(vc: UIViewController, animation: Bool = true) {
        self.pushViewController(vc, animated: animation)
        if self.children.count > 1 {
            vc.hidesBottomBarWhenPushed = true
        }
    }
    
    func pop(animation: Bool = true) {
        self.popViewController(animated: animation)
        if self.children.count <= 1 {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    func popTOVC(taget: AnyClass?) {
        var targetVC: UIViewController?
        for vc in self.children {
            if vc.classForCoder == taget {
                targetVC = vc
            }
        }
        if let vc = targetVC {
            self.popToViewController(vc, animated: true)
        } else {
            self.pop()
        }
        
    }
    
    func haveVC(taget: AnyClass) -> Bool {
        for vc in self.children {
            if vc.classForCoder == taget {
                return true
            }
        }
        return false
    }
}
