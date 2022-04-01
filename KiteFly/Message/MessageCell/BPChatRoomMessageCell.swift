//
//  BPChatRoomCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit
import RongIMLib

/// 聊天室消息类型Cell
class BPChatRoomMessageCell: BPChatRoomBaseCell, BPChatRoomBubbleDelegate {
    
    /// 头像
    private var avatarImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.size = CGSize(width: AdaptSize(40), height: AdaptSize(40))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    /// 气泡背景
    internal var bubbleView = BPChatRoomBaseMessageBubble()
    /// 消息状态
    private var statusView  = BPChatRoomMessageCellStatusView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
        self.updateUI()
        self.registerNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.customContentView.addSubview(avatarImageView)
        self.customContentView.addSubview(bubbleView)
        self.customContentView.addSubview(statusView)
        self.avatarImageView.layer.cornerRadius = AdaptSize(20)
    }

    override func bindProperty() {
        super.bindProperty()
        self.bubbleView.delegate = self
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(clickAvatarAction))
        self.avatarImageView.isUserInteractionEnabled = true
        self.avatarImageView.addGestureRecognizer(tapGes)
        let tapStatusGes = UITapGestureRecognizer(target: self, action: #selector(didTapStatusGes))
        self.statusView.addGestureRecognizer(tapStatusGes)
    }
    
    override func updateUI() {
        super.updateUI()
        self.backgroundColor = UIColor.clear
    }
    
    override func registerNotification() {
        super.registerNotification()
    }

    // MARK: ==== Evnet ====
    override func bindData(message model: RCMessage, indexPath: IndexPath) {
        super.bindData(message: model, indexPath: indexPath)
        self.updateUI()
        // 设置头像
        self.setAvatar()
        // 设置内容展示视图
        self.setBubbleView()
        // 设置状态视图
        self.setStatusView()
    }
    
    @objc private func clickAvatarAction() {
        guard let model = self.messageModel, let indexPath = self.indexPath else { return }
        self.delegate?.clickAvatarAction(model: model, indexPath: indexPath)
    }
    
    /// 重发
    @objc
    private func didTapStatusGes() {
        guard let model = self.messageModel, let indexPath = self.indexPath, model.messageDirection == .MessageDirection_SEND else { return }
        guard self.statusView.type == .fail else {
            return
        }
        self.delegate?.resendMessage(model: model, indexPath: indexPath)
    }
    
    @objc
    private func updateStatus(sender: Notification) {
        guard let _messageModel = sender.userInfo?["message"] as? RCMessage, let messageModel = self.messageModel else { return }
        if _messageModel == messageModel {
            switch _messageModel.sentStatus {
            case .SentStatus_SENT:
                self.statusView.setStatus(type: .normal)
            case .SentStatus_FAILED:
                self.statusView.setStatus(type: .fail)
            default:
                break
            }
            
        }
    }

    // MARK: ==== Tools ===
    
    /// 设置头像
    private func setAvatar() {
        guard let model = self.messageModel else { return }
        if model.messageDirection == .MessageDirection_SEND {
            self.avatarImageView.setImage(with: KFUserModel.share.avatar)
            self.avatarImageView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(topSpace)
                make.right.equalToSuperview().offset(AdaptSize(-16))
                make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(40)))
                make.bottom.lessThanOrEqualToSuperview().offset(bottomSpace)
            }
        } else {
            self.avatarImageView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(topSpace)
                make.left.equalToSuperview().offset(AdaptSize(16))
                make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(40)))
                make.bottom.lessThanOrEqualToSuperview().offset(bottomSpace)
            }
        }
    }
    
    /// 设置内容展示视图
    func setBubbleView() {
        self.bubbleView.messageModel = self.messageModel
        guard let model = self.messageModel else { return }
        if model.messageDirection == .MessageDirection_SEND {
            self.bubbleView.snp.remakeConstraints { (make) in
                make.right.equalTo(avatarImageView.snp.left).offset(AdaptSize(-10))
                make.top.equalTo(avatarImageView)
                make.bottom.equalToSuperview().offset(bottomSpace)
            }
        } else {
            self.bubbleView.snp.remakeConstraints { (make) in
                make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize(10))
                make.top.equalTo(avatarImageView)
                make.bottom.equalToSuperview().offset(bottomSpace)
            }
        }
    }
    
    /// 设置状态视图
    private func setStatusView() {
        guard let model = self.messageModel else { return }
        if model.messageDirection != .MessageDirection_SEND && model.objectName != RCHQVoiceMessage.getObjectName() {
            // 不是发送的消息或者接收的语音，直接返回
            self.statusView.isHidden = true
            return
        }
        self.statusView.isHidden = false

        if model.messageDirection == .MessageDirection_SEND {
            statusView.snp.remakeConstraints { make in
                make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
                make.right.equalTo(bubbleView.snp.left).offset(AdaptSize(-10))
                make.centerY.equalTo(bubbleView)
            }
        } else {
            statusView.snp.remakeConstraints { make in
                make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
                make.left.equalTo(bubbleView.snp.right).offset(AdaptSize(10))
                make.centerY.equalTo(bubbleView)
            }
        }
        
        if model.messageDirection == .MessageDirection_SEND {
            // 风控修改的本地失败状态
            if let exDic = model.expansionDic, let statusStr = exDic["sendStatus"], let status = RCSentStatus(rawValue: UInt(statusStr.intValue)) {
                model.sentStatus = status
            }
            switch model.sentStatus {
            case .SentStatus_SENDING:
                self.statusView.setStatus(type: .loading)
            case .SentStatus_FAILED:
                self.statusView.setStatus(type: .fail)
            default:
                self.statusView.setStatus(type: .normal)
            }
        } else {
            if model.objectName == RCHQVoiceMessage.getObjectName() {
                if model.receivedStatus == .ReceivedStatus_LISTENED {
                    self.statusView.setStatus(type: .normal)
                } else {
                    self.statusView.setStatus(type: .unread)
                }
            } else {
                if model.receivedStatus == .ReceivedStatus_UNREAD {
                    self.statusView.setStatus(type: .unread)
                } else {
                    self.statusView.setStatus(type: .normal)
                }
            }
        }
    }

    // MARK: ==== BPChatRoomBubbleDelegate ====
    /// 点击气泡
    func clickBubble() {
        guard let _messageModel = self.messageModel, let _indexPath = self.indexPath else {
            return
        }
        self.delegate?.clickBubble(model: _messageModel, indexPath: _indexPath)
        // 如果是语音且未读，则更新未已读
        if _messageModel.messageDirection == .MessageDirection_RECEIVE {
            if _messageModel.objectName == RCHQVoiceMessage.getObjectName()
                &&
                _messageModel.receivedStatus != .ReceivedStatus_LISTENED
            {
                _messageModel.receivedStatus = .ReceivedStatus_LISTENED
                self.statusView.setStatus(type: .normal)
            }
        }
    }

    /// 撤回消息
    func withDrawMessage() {
        guard let _messageModel = self.messageModel, let _indexPath = self.indexPath else {
            return
        }
        self.delegate?.withdrawAction(model: _messageModel, indexPath: _indexPath)
    }
    
    /// 删除消息
    func deleteMessage() {
        guard let _messageModel = self.messageModel, let _indexPath = self.indexPath else {
            return
        }
        self.delegate?.deleteMessageAction(model: _messageModel, indexPath: _indexPath, complete: { result in
            if result {
                kWindow.toast("删除成功")
            } else {
                kWindow.toast("删除失败")
            }
        }, isReload: true)
    }
}
