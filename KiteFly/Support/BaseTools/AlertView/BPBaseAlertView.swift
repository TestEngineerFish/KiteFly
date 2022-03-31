//
//  BPBaseAlertView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 优先级由高到低
public enum BPAlertPriorityEnum: Int {
    case A = 0
    case B = 1
    case C = 2
    case D = 3
    case E = 4
    case F = 5
    case normal = 100
}

/// AlertView的基类,默认只显示标题或者标题+描述信息
open class BPBaseAlertView: BPTopWindowView {
    
    /// 弹框优先级
    public var priority: BPAlertPriorityEnum = .normal
    /// 是否已展示过
    public var isShowed = false
    /// 默认事件触发后自动关闭页面
    public var autoClose: Bool = true
    /// 确定按钮是否标红（破坏性操作警告）
    public var isDestruct: Bool = false
    
    /// 弹框的默认宽度
    public var mainViewWidth = AdaptSize(275)
    /// 弹框的默认高度
    public var mainViewHeight: CGFloat = .zero
    /// 弹框内容最大高度
    public var maxContentHeight: CGFloat = AdaptSize(300)
    
    /// 间距
    public let leftPadding: CGFloat   = AdaptSize(20)
    public let rightPadding: CGFloat  = AdaptSize(20)
    public let topPadding: CGFloat    = AdaptSize(20)
    public let bottomPadding: CGFloat = AdaptSize(25)
    public let defaultSpace: CGFloat  = AdaptSize(15)
    public let closeBtnSize: CGSize   = CGSize(width: AdaptSize(50), height: AdaptSize(50))
    
    public let webCotentHeight        = AdaptSize(300)
    public let imageViewSize: CGSize  = CGSize(width: AdaptSize(300), height: AdaptSize(500))
    
    // 标题的高度
    public var titleHeight: CGFloat {
        get {
            return self.titleLabel.textHeight(width: mainViewWidth - leftPadding - rightPadding)
        }
    }
    // 描述的高度
    public var descriptionHeight: CGFloat {
        get {
            return self.descriptionLabel.textHeight(width: mainViewWidth - leftPadding - rightPadding)
        }
    }
    
    public var descriptionText: String = ""
    public var imageUrlStr: String?
    public var leftActionBlock: DefaultBlock?
    public var rightActionBlock: DefaultBlock?
    public var closeActionBlock: DefaultBlock?
    public var imageActionBlock: ((String?)->Void)?
    
    // 弹框的背景
    open var mainView: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.white
        view.layer.cornerRadius  = AdaptSize(15)
        view.layer.masksToBounds = true
        return view
    }()

    // 弹窗标题
    open var titleLabel: UILabel = {
        let label           = UILabel()
        label.numberOfLines = 1
        label.textColor     = UIColor.black2
        label.font          = UIFont.semiboldFont(ofSize: AdaptSize(20))
        label.textAlignment = .center
        return label
    }()
    
    open var contentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator   = false
        return scrollView
    }()
    
    /// 自定义富文本视图
    open var attributionView: BPAttributionView?

    // 弹窗描述
    open var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    /// 背景图
    internal var backgroundImage: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleToFill
        imageView.image       = UIImage(named: "dynamic_icon_bg")
        return imageView
    }()
    
    /// 左边按钮
    open var leftButton: BPButton = {
        let button = BPButton(.normal, size: CGSize(width: AdaptSize(100), height: AdaptSize(35)))
        button.backgroundColor = UIColor.gray3
        button.setTitleColor(UIColor.black2, for: .normal)
        button.titleLabel?.font    = UIFont.semiboldFont(ofSize: AdaptSize(14))
        button.layer.cornerRadius  = AdaptSize(17.5)
        button.layer.masksToBounds = true
        return button
    }()

    /// 右边按钮
    open var rightButton: BPButton = {
        let button = BPButton(.theme, size: CGSize(width: AdaptSize(100), height: AdaptSize(35)))
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font    = UIFont.semiboldFont(ofSize: AdaptSize(14))
        button.layer.cornerRadius  = AdaptSize(17.5)
        button.layer.masksToBounds = true
        return button
    }()
    
    open override func createSubviews() {
        super.createSubviews()
        self.addSubview(mainView)
        self.mainView.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    open override func bindProperty() {
        super.bindProperty()
        self.leftButton.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
    open override func show(view: UIView = kWindow) {
        super.show(view: view)
        UIViewController.currentViewController?.view.endEditing(true)
        // 果冻动画
        self.mainView.layer.addJellyAnimation()
    }

    @objc
    open func leftAction() {
        self.leftActionBlock?()
        if autoClose {
            self.hide()
        }
    }

    @objc
    open func rightAction() {
        self.rightActionBlock?()
        if autoClose {
            self.hide()
        }
    }
    
    @objc
    open override func hide() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.mainView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        super.hide()
        self.closeActionBlock?()
    }
}
