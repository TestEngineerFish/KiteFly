//
//  BPChatRoomBaseMessageCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit
import RongIMLib

protocol BPChatRoomBubbleDelegate: NSObjectProtocol {
    /// 点击气泡
    func clickBubble()
    /// 撤回消息
    func withDrawMessage()
    /// 删除消息
    func deleteMessage()
}

/// 所有消息气泡的基类
class BPChatRoomBaseMessageBubble: BPView {

    var messageModel: RCMessage?
    /// 最大长度
    var maxWidth: CGFloat = AdaptSize(250)
    weak var delegate: BPChatRoomBubbleDelegate?
    
    internal var backgroundImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius  = AdaptSize(10)
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.isUserInteractionEnabled = true
        self.backgroundColor          = .clear
        
        // 设置手势事件
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.clickBubbleAction))
        self.addGestureRecognizer(tapAction)

        let longPressAction = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressBubbleAction(sender:)))
        self.addGestureRecognizer(longPressAction)
    }

    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    // MARK: ==== Event ====
    
    func setLeftWhiteBackground() {
        self.backgroundImageView.image = UIImage.imageWithColor(.white)
    }
    
    func setRightGreenBackground() {
        self.backgroundImageView.image = UIImage.imageWithColor(.theme)
    }
    
    func setRightWhiteBackground() {
        self.backgroundImageView.image = UIImage.imageWithColor(.white)
    }

    /// 点击bubble区域事件
    @objc func clickBubbleAction() {
        self.delegate?.clickBubble()
    }

    /// 长按Bubble区域事件
    @objc func longPressBubbleAction(sender: UILongPressGestureRecognizer) {
        guard let messageModel = messageModel else {
            return
        }
        
        if sender.state == .began {
            UIViewController.currentViewController?.view.endEditing(true)
            let actionSheet = BPActionSheet()
            actionSheet.addItem(icon: UIImage(named: "dynamic_comment_delete"), title: "删除", isDestroy: true) {
                self.delegate?.deleteMessage()
            }.show()
        }
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
//        // 仅文本支持复制
//        if action == #selector(UIResponderStandardEditActions.copy(_:)) && self.messageModel.objectName == RCTextMessage.getObjectName() || action == #selector(deleteAction) {
//            return true
//        } else {
//            return false
//        }
    }

    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = self.messageModel?.text
    }

    @objc private func withDrawAction() {
        self.delegate?.withDrawMessage()
    }
    
    @objc private func deleteAction() {
        self.delegate?.deleteMessage()
    }
}
