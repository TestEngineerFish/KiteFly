//
//  BPAlertManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

public class BPAlertManager {
    
    public static var share = BPAlertManager()
    private var alertArray  = [BPBaseAlertView]()
    private var isShowing   = false
    
    public func show() {
        guard !self.isShowing else {
            return
        }
        self.isShowing = true
        // 排序
        self.alertArray.sort(by: { $0.priority.rawValue < $1.priority.rawValue })
        guard let alertView = self.alertArray.first else {
            return
        }
        // 关闭弹框后的闭包
        alertView.closeActionBlock = { [weak self] in
            guard let self = self else { return }
            self.isShowing = false
            self.removeAlert()
        }
        alertView.show()
    }

    /// 添加一个alertView
    /// - Parameter alertView: alert对象
    public func addAlert(alertView: BPBaseAlertView) {
        self.alertArray.append(alertView)
    }

    /// 移除当前已显示的Alert
    public func removeAlert() {
        guard !self.alertArray.isEmpty else {
            return
        }
        self.alertArray.removeFirst()
        // 如果队列中还有未显示的Alert，则继续显示
        guard !self.alertArray.isEmpty else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.show()
        }
    }
    
    // MARK: ==== Alert view ====
    
    /// 显示底部一个按钮的弹框， 默认内容居中
    @discardableResult
    public func oneButton(title: String?, description: String, buttonName: String, closure: (() -> Void)?) -> BPBaseAlertView {
        let alertView = BPAlertViewOneButton(title: title, description: description, buttonName: buttonName, closure: closure)
        self.addAlert(alertView: alertView)
        return alertView
    }
    
    /// 显示底部两个按钮的弹框
    public func twoButton(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?, isDestruct: Bool = false) -> BPBaseAlertView {
        let alertView = BPAlertViewTwoButton(title: title, description: description, leftBtnName: leftBtnName, leftBtnClosure: leftBtnClosure, rightBtnName: rightBtnName, rightBtnClosure: rightBtnClosure, isDestruct: isDestruct)
        self.addAlert(alertView: alertView)
        return alertView
    }
}
