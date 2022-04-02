//
//  KFView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit
import SnapKit

public protocol KFViewDelegate: NSObjectProtocol {
    /// 初始化子视图
    func createSubviews()
    /// 初始化属性
    func bindProperty()
    /// 初始化数据
    func bindData()
    /// 更新UI颜色、图片
    func updateUI()
}

open class KFView: UIView, KFViewDelegate {
    
    deinit {
        #if DEBUG
        print(self.classForCoder, "资源释放")
        #endif
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    
    // MARK: ==== KFViewDelegate ====
    open func createSubviews() {}
    
    open func bindProperty() {}
    
    open func bindData() {}
    
    open func registerNotification() {}
    
    open func updateUI() {}
    
}
