//
//  BPNavigationBar.swift
//  MessageCenter
//
//  Created by apple on 2021/10/28.
//  Copyright © 2021 KLC. All rights reserved.
//

import UIKit

public protocol KFNavigationBarDelegate: NSObjectProtocol {
    func leftAction()
    func rightAction()
}

open class KFNavigationBar: TYView_ty {
    
    public var leftViewList: [UIView]  = []
    public var rightViewList: [UIView] = []
    public weak var delegate: KFNavigationBarDelegate?
    
    private let buttonSize = CGSize(width: AdaptSize(53), height: AdaptSize(27))
    private let leftOffsetX: CGFloat  = AdaptSize(12)
    private let rightOffsetX: CGFloat = AdaptSize(-12)
    
    /// 设置大标题
    public var isBigTitle: Bool = false {
        didSet {
            self.setBigTitle()
        }
    }
    
    public var titleLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.font          = UIFont.iconFont(size: AdaptSize(18))
        label.textAlignment = .center
        label.textColor     = UIColor.white
        return label
    }()
    
    public var leftButton: KFButton = {
        let button = KFButton()
//        button.setImage(UIImage(named: "app_back_nomal"), for: .normal)
        button.setTitle(IconFont.back.rawValue, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(16))
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.white)
        return button
    }()
    
    public var rightButton: KFButton = {
        let button = KFButton()
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(16))
        button.isHidden = true
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.white)
        return button
    }()
    
    public var leftTitle: String? = "" {
        willSet {
            self.leftButton.setTitle(newValue, for: .normal)
            let _width = self.leftButton.sizeThatFits(CGSize(width: kScreenWidth, height: self.buttonSize.height)).width
            self.leftButton.snp.updateConstraints { (make) in
                make.width.equalTo(_width + AdaptSize(10))
            }
        }
    }
    
    public var title: String? = "" {
        willSet {
            self.titleLabel.text = newValue
        }
    }
    
    public var rightTitle: String? {
        set {
            self.rightButton.setTitle(newValue, for: .normal)
            self.rightButton.isHidden = false
            let _width = self.rightButton.sizeThatFits(CGSize(width: kScreenWidth, height: self.buttonSize.height)).width
            self.rightButton.snp.updateConstraints { (make) in
                make.width.equalTo(_width + AdaptSize(10))
            }
        }
        get {
            return self.rightButton.currentTitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.updateUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.addSubview(leftButton)
        self.addSubview(titleLabel)
        self.addSubview(rightButton)
        leftButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(leftOffsetX).priority(.low)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(buttonSize.width)
            make.height.equalTo(buttonSize.height)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(leftButton.snp.right).offset(AdaptSize(5))
            make.right.lessThanOrEqualTo(rightButton.snp.left).offset(-AdaptSize(5))
            make.height.equalTo(titleLabel.font.lineHeight)
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(rightOffsetX).priority(.low)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(buttonSize.width)
            make.height.equalTo(buttonSize.height)
        }
    }
    
    public override func bindProperty() {
        super.bindProperty()
        self.leftButton.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        // 设置默认标题
        if let currentVC = UIViewController.currentViewController {
            self.title      = currentVC.title
//            self.rightTitle = currentVC.rightText
//            self.rightButton.setImage(currentVC.rightImage, for: .normal)
        }
        self.backgroundColor = .theme
    }
    
    // MARK: ==== Event ====
    @objc
    private func leftAction(btn: KFButton) {
        btn.setStatus(.disable)
        self.delegate?.leftAction()
        btn.setStatus(.normal)
    }
    
    @objc
    private func rightAction(btn: KFButton) {
        btn.setStatus(.disable)
        self.delegate?.rightAction()
        btn.setStatus(.normal)
    }
    
    public func hideLeftView() {
        self.leftButton.isHidden = true
        self.leftViewList.forEach { view in
            view.isHidden = true
        }
    }
    
    public func removeLeftAllView() {
        self.leftButton.isHidden = true
        self.leftButton.removeFromSuperview()
        self.leftViewList.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    public func removeRightAllView() {
        self.rightButton.isHidden = true
        self.rightButton.removeFromSuperview()
        self.rightViewList.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    public func hideRightView() {
        self.rightButton.isHidden = true
        self.rightViewList.forEach { view in
            view.isHidden = true
        }
    }
    
    public func clearBar() {
        self.leftViewList.forEach { view in
            view.removeFromSuperview()
        }
        self.rightViewList.forEach { view in
            view.removeFromSuperview()
        }
        self.leftViewList.removeAll()
        self.rightViewList.removeAll()
    }
    
    /// 添加按钮到左侧
    /// - Parameter button: 按钮对象
    /// - Description 从左往右添加，可提前设置按钮大小
    public func addLeftView(views: [UIView]) {
        if leftViewList.isEmpty && !self.leftButton.isHidden {
            self.leftViewList = [leftButton]
        }
        self.leftViewList += views
        // 调整布局
        var _leftOffsetX = self.leftOffsetX
        for view in leftViewList {
            self.addSubview(view)
            view.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(_leftOffsetX)
                make.centerY.equalTo(titleLabel)
                if view.size == CGSize.zero {
                    make.size.equalTo(buttonSize)
                    _leftOffsetX += buttonSize.width
                } else {
                    make.size.equalTo(view.size)
                    _leftOffsetX += view.width
                }
            }
        }
        // 计算右侧所有按钮的总宽度
        var _rightOffsetX = CGFloat.zero
        if let lastRightView = self.rightViewList.last {
            _rightOffsetX = kScreenWidth - lastRightView.left
        } else if !self.rightButton.left.isZero {
            _rightOffsetX = kScreenWidth - self.rightButton.left
        }
        let _offset = max(_leftOffsetX, _rightOffsetX) + AdaptSize(5)
        titleLabel.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
            make.left.equalToSuperview().offset(_offset)
            make.right.equalToSuperview().offset(-_offset)
            make.height.equalTo(titleLabel.font.lineHeight)
        }
    }
    
    /// 添加按钮到右侧
    /// - Parameter button: 按钮对象
    /// - Description 从右往左添加，可提前设置按钮大小
    public func addRightView(views: [UIView]) {
        if rightViewList.isEmpty && !self.rightButton.isHidden {
            self.rightViewList = [rightButton]
        }
        self.rightViewList += views
        // 调整布局
        var _rightOffsetX: CGFloat = 0.0
        for view in rightViewList {
            self.addSubview(view)
            view.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(_rightOffsetX)
                make.centerY.equalTo(titleLabel)
                if view.size == CGSize.zero {
                    make.size.equalTo(buttonSize)
                    _rightOffsetX -= buttonSize.width
                } else {
                    make.size.equalTo(view.size)
                    _rightOffsetX -= view.width
                }
            }
        }
        // 计算左侧所有按钮的总宽度
        var _leftOffsetX = CGFloat.zero
        if let lastLeftView = self.leftViewList.last {
            _leftOffsetX = lastLeftView.right
        } else if !self.leftButton.right.isZero  {
            _leftOffsetX = self.leftButton.right
        }
        let offset = max(_leftOffsetX, -_rightOffsetX) + AdaptSize(5)
        self.titleLabel.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
            make.left.equalToSuperview().offset(offset)
            make.right.equalToSuperview().offset(-offset)
            make.height.equalTo(titleLabel.font.lineHeight)
        }
    }
    

    /// 设置大字体
    private func setBigTitle() {
        if isBigTitle {
            self.leftButton.titleLabel?.font = UIFont.mediumFont(ofSize: AdaptSize(20))
            self.leftButton.setTitle(title, for: .normal)
            self.titleLabel.isHidden = true
            self.leftButton.sizeToFit()
            self.leftButton.snp.updateConstraints { (make) in
                make.width.equalTo(leftButton.width)
                make.height.equalTo(leftButton.height)
            }
        } else {
            self.leftButton.titleLabel?.font = UIFont.iconFont(size: AdaptSize(16))
            self.leftButton.setTitle(IconFont.back.rawValue, for: .normal)
            self.titleLabel.isHidden = false
            self.leftButton.sizeToFit()
            self.leftButton.snp.updateConstraints { (make) in
                make.width.equalTo(AdaptSize(40))
                make.height.equalTo(AdaptSize(26))
            }
        }
    }
}
