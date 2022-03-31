//
//  BPActionSheet.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/3.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit
import SnapKit

@objc
open class BPActionSheet: BPTopWindowView {

    public let cellHeight: CGFloat  = AdaptSize(55)
    let lineHeight: CGFloat  = 1/UIScreen.main.scale
    let spaceHeight: CGFloat = AdaptSize(7)
    public var maxH = CGFloat.zero
    var buttonList: [BPButton] = []
    public var actionDict: [String:DefaultBlock] = [:]
    private var title: String?

    /// 无裁切的底部视图的父视图
    public var contentView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    /// 负责显示视图的底视图
    public var mainView: UIView = {
        let view = UIView()
        view.backgroundColor    = UIColor.white
        view.layer.cornerRadius = AdaptSize(8)
        return view
    }()
    
    public init(title: String? = nil) {
        super.init(frame: .zero)
        self.title = title
        self.createSubviews()
        self.bindProperty()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func createSubviews() {
        super.createSubviews()
        self.addSubview(contentView)
        contentView.addSubview(mainView)
        self.addTitle()
    }

    public override func bindProperty() {
        super.bindProperty()
    }

    // MARK: ==== Event ====
    @discardableResult @objc
    public func addItem(icon: UIImage? = nil, title: String, isDestroy: Bool = false, actionBlock: DefaultBlock?) -> BPActionSheet {
        let button = BPButton(.normal)
        button.setTitle(title, for: .normal)
        if isDestroy {
            button.setTitleColor(UIColor.red1)
        } else {
            button.setTitleColor(UIColor.black2)
        }
        if let _icon = icon {
            button.setImage(_icon, for: .normal)
            button.imageView?.size = CGSize(width: AdaptSize(20), height: AdaptSize(20))
        }
        button.titleLabel?.font = UIFont.semiboldFont(ofSize: AdaptSize(15))
        button.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        mainView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(maxH)
            make.height.equalTo(cellHeight)
        }
        maxH += cellHeight
        self.buttonList.append(button)
        if actionBlock != nil {
            self.actionDict[title] = actionBlock
        }
        return self
    }
    
    /// 添加标题
    private func addTitle() {
        guard let _title = self.title else { return }
        let label = BPLabel()
        label.text          = _title
        label.textColor     = UIColor.gray5
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(14))
        label.textAlignment = .center
        mainView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(maxH)
            make.height.equalTo(cellHeight)
        }
        maxH += cellHeight
    }

    /// 添加默认的底部间距和取消按钮
    private func addDefaultItem() {
        let spaceView = UIView()
        spaceView.backgroundColor = .gray0
        mainView.addSubview(spaceView)
        spaceView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(maxH)
            make.height.equalTo(spaceHeight)
        }
        maxH += spaceHeight

        let cancelButton = BPButton()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = UIFont.semiboldFont(ofSize: AdaptSize(15))
        cancelButton.setTitleColor(UIColor.black2)
        cancelButton.addTarget(self, action: #selector(self.hide), for: .touchUpInside)
        mainView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(spaceView.snp.bottom)
            make.height.equalTo(cellHeight)
        }
        maxH += cellHeight + kSafeBottomMargin
        self.buttonList.append(cancelButton)
    }

    private func adjustMainView() {
        mainView.size = CGSize(width: kScreenWidth, height: maxH)
        mainView.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(15))
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(maxH)
            make.top.equalTo(self.snp.bottom)
        }
    }
    
    @objc public func clickAction(sender: BPButton) {
        guard let title = sender.currentTitle else {
            print("暂无事件")
            return
        }
        self.actionDict[title]?()
        // 默认点击后收起ActionSheet
        self.hide()
    }
    
    

    @objc
    public override func hide() {
        super.hide()
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.contentView.transform = .identity
        } completion: { [weak self] (finished) in
            guard let self = self else { return }
            if finished {
                self.removeFromSuperview()
            }
        }
    }

    public override func show(view: UIView = kWindow) {
        super.show(view: view)
        self.addDefaultItem()
        self.adjustMainView()
        shake()
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.maxH)
        }
    }
}
