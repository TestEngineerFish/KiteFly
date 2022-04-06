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
        let url  = "https://oapi.dingtalk.com/robot/send?access_token=ce9a301a2ecf61146066a9bdf0e1f8795e86e69a7085c58e78bcdb86204dd93e"
        let json = ["msgtype": "text","text": ["content":"通知：\(content)"]].toJson()
        if let url = URL(string: url) {
            var urlReqeust = URLRequest(url: url)
            urlReqeust.httpMethod = HTTPMethod.post.rawValue
            urlReqeust.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            urlReqeust.httpBody = json.data(using: .utf8)
            AF.request(urlReqeust).responseJSON { json in
                print("Success\(json)")
            }
        }
    }
}
