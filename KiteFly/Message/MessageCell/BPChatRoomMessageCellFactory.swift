//
//  BPChatRoomMessageCellFactory.swift
//  Tenant
//
//  Created by samsha on 2021/8/25.
//

import UIKit
import RongIMLib

/// 消息工厂
struct BPChatRoomMessageCellFactory {
    /// 普通消息
    static let normalCellID   = "kBPChatRoomMessageCell"
    
    static let textCellID     = "kBPChatRoomMessageTextCell"
    static let audioCellID    = "kBPChatRoomMessageAudioCell"
    static let giftCellID     = "kBPChatRoomMessageGiftCell"
    static let imageCellID    = "kBPChatRoomMessageImageCell"
    static let callCellID     = "kBPChatRoomMessageCallCell"
    
    /// 撤回消息
    static let withdrawCellID = "kBPChatRoomWithDrawCell"
    /// 提示消息
    static let tipsCellID     = "kBPChatRoomTipsCell"
    /// 空
    static let emptyCellID    = "kEmptyCellID"
    
    static func buildCell(tableView: UITableView, message model: RCMessage) -> BPChatRoomBaseCell? {
        switch model.objectName {
        case RCTextMessage.getObjectName():
            let cell = tableView.dequeueReusableCell(withIdentifier: textCellID) as? BPChatRoomMessageTextCell
            return cell
        case RCHQVoiceMessage.getObjectName():
            let cell = tableView.dequeueReusableCell(withIdentifier: audioCellID) as? BPChatRoomMessageAudioCell
            return cell
        case RCImageMessage.getObjectName():
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCellID) as? BPChatRoomMessageImageCell
            return cell
        default:
            return nil
        }
    }
}
