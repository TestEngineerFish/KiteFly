//
//  BPChatRoomBaseCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/21.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit
import RongIMLib

protocol BPChatRoomCellDelegate: NSObjectProtocol {
    /// 点击消息
    func clickBubble(model: RCMessage, indexPath: IndexPath)
    /// 撤回
    func withdrawAction(model: RCMessage, indexPath: IndexPath)
    /// 重新编辑
    func reeditAction(model: RCMessage, indexPath: IndexPath)
    /// 点击头像
    func clickAvatarAction(model: RCMessage, indexPath: IndexPath)
    /// 删除消息
    func deleteMessageAction(model: RCMessage, indexPath: IndexPath, complete block: BoolBlock?, isReload: Bool)
    /// 重发消息
    func resendMessage(model: RCMessage, indexPath: IndexPath)
    /// 更新大小（小灰条宽度，cell高度）
    func updateCellSize(size: CGSize, model: RCMessage, indexPath: IndexPath)
}

/// 聊天室所有类型消息的基类
class BPChatRoomBaseCell: BPTableViewCell {
    
    let topSpace    = AdaptSize(10)
    let bottomSpace = AdaptSize(-10)
    let timeHeight  = AdaptSize(36)
    var messageModel: RCMessage?
    
    weak var delegate: BPChatRoomCellDelegate?
    
    var timeLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(11))
        label.textAlignment = .center
        label.isHidden      = true
        return label
    }()
    
    var customContentView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    override func createSubviews() {
        super.createSubviews()
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(customContentView)
        timeLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(0)
        }
        customContentView.snp.remakeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    override func bindProperty() {
        self.selectionStyle  = .none
        self.backgroundColor = .clear
    }
    
    /// 设置数据
    /// - Parameters:
    ///   - model: 消息对象
    ///   - indexPath: 下标
    func bindData(message model: RCMessage, indexPath: IndexPath) {
        self.messageModel = model
        self.indexPath    = indexPath
        self.setTimestamp(model: model)
    }
    
    // 时间戳
    private func setTimestamp(model: RCMessage) {
        let currentDate = Date(timeIntervalSince1970: TimeInterval(max(model.sentTime, model.receivedTime)/1000))
        self.timeLabel.isHidden = true
        self.timeLabel.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
    }
}
