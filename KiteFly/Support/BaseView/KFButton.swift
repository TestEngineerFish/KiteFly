//
//  BPBaseButton.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation


public enum KFButtonStatusEnum: Int {
    case normal
    case touchDown
    case disable
}

public enum KFButtonType: Int {
    /// 普通的按钮，无特殊样式
    case normal
    /// 主按钮，主题蓝色渐变背景样式
    case theme
    /// 次按钮，主题蓝色边框样式
    case second
}

@IBDesignable
open class KFButton: UIButton {
    
    public var status: KFButtonStatusEnum = .normal
    public var type: KFButtonType
    public var showAnimation: Bool
    
    /// 正常状态透明度
    public var normalOpacity:Float  = 1.0
    /// 禁用状态透明度
    public var disableOpacity:Float = 0.3
    
    
    // MARK: ---- Init ----
    
    public init(_ type: KFButtonType = .normal, size: CGSize = .zero, animation: Bool = true) {
        self.type          = type
        self.showAnimation = animation
        super.init(frame: CGRect(origin: .zero, size: size))
        
        self.bindProperty()
        self.addTarget(self, action: #selector(touchDown(sender:)), for: .touchDown)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchUpOutside)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchCancel)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeTarget(self, action: #selector(touchDown(sender:)), for: .touchDown)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchUpInside)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchUpOutside)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchCancel)
    }
    
    // MARK: ---- Layout ----
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        // 约束设置
        self.setStatus(nil)
    }
    
    /// 设置按钮状态，根据状态来更新UI
    open func setStatus(_ status: KFButtonStatusEnum?) {
        if let _status = status {
            self.status = _status
        }
        switch self.status {
        case .normal:
            self.isEnabled     = true
            if self.type == .theme {
                self.backgroundColor = UIColor.theme
            } else {
                self.layer.opacity = normalOpacity
            }
        case .touchDown:
            break
        case .disable:
            self.isEnabled     = false
            if self.type == .theme {
                self.backgroundColor = UIColor.gray3
            } else {
                self.layer.opacity = disableOpacity
            }
        }
    }
    
    // MARK: ---- Event ----
    open func bindProperty() {
        switch type {
        case .normal:
            self.setTitleColor(UIColor.black0)
        case .theme:
            self.setTitleColor(UIColor.white)
            self.layer.cornerRadius  = AdaptSize(5)
            self.layer.masksToBounds = true
            self.backgroundColor     = UIColor.theme
        case .second:
            self.setTitleColor(UIColor.white)
            self.backgroundColor     = UIColor.white
            self.layer.cornerRadius  = AdaptSize(5)
            self.layer.masksToBounds = true
            self.layer.borderColor   = UIColor.theme.cgColor
            self.layer.borderWidth   = AdaptSize(1)
            self.setTitleColor(.theme)
        }
    }
    
    open func setTitleColor(_ color: UIColor?) {
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color, for: .highlighted)
    }
    
    @objc
    private func touchDown(sender: UIButton) {
        self.isEnabled = true
        if type != .normal {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.7)
        }
        guard self.showAnimation else {
            return
        }
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values       = [0.9]
        animation.duration     = 0.1
        animation.autoreverses = false
        animation.fillMode     = .forwards
        animation.isRemovedOnCompletion = false
        sender.layer.add(animation, forKey: nil)
    }
    
    @objc
    private func touchUp(sender: UIButton) {
        if type != .normal {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(1.0)
        }
        guard self.showAnimation else {
            return
        }
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values       = [1.1, 0.95, 1.0]
        animation.duration     = 0.2
        animation.autoreverses = false
        animation.fillMode     = .forwards
        animation.isRemovedOnCompletion = false
        sender.layer.add(animation, forKey: nil)
    }
    
    //TODO: 自定义Storyboard编辑器
    @IBInspectable
    open var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius  = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable
    open var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    open var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
