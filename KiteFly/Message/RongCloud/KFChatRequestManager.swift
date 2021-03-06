//
//  BPChatRequestManager.swift
//  MessageCenter
//
//  Created by apple on 2021/11/2.
//  Copyright © 2021 KLC. All rights reserved.
//

import RongIMLib
import UIKit
import Alamofire
import STYKit

struct KFChatRequestManager {
    static let share = KFChatRequestManager()
  
    /// 获取历史消息
    /// - Parameters:
    ///   - sessionId: 会话ID
    ///   - lastMessageId: 从哪一条消息前开始获取
    ///   - count: 获取条数
    /// - Returns: 消息列表
    func requestHistoryMessaes(sessionId: String, lastMessageId: Int?, lastMessageTime: Date?, count: Int32) -> [RCMessage] {
        let lastId = lastMessageId ?? -1
        var messageList = RCIMClient.shared().getHistoryMessages(.ConversationType_PRIVATE, targetId: sessionId, oldestMessageId: lastId, count: count) as? [RCMessage] ?? []
        messageList.reverse()
        // 设置是否显示时间戳
        var lastTime: Date? = lastMessageTime
        messageList = messageList.filter({$0.objectName == RCTextMessage.getObjectName() || $0.objectName == RCImageMessage.getObjectName() || $0.objectName == RCHQVoiceMessage.getObjectName() })
        messageList.forEach { message in
            message.updateShowTimeStatus(lastMessageTime: lastTime)
            message.canIncludeExpansion = true
            lastTime = message.time
        }
        return messageList
    }
    
    func requestRecord(content: String) {
        
        let request = KFRequest.sendLog(msg: content)
        TYNetworkManager_ty.share_ty.request_ty(TYResponseNil_ty.self, request_ty: request, success_ty: nil, fail_ty: nil)
    }
}
