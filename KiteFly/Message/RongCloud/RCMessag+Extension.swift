//
//  RCMessage+Extension.swift
//  MessageCenter
//
//  Created by apple on 2021/11/5.
//  Copyright © 2021 KLC. All rights reserved.
//

import RongIMLib
import Foundation

extension RCMessage {
    
    private struct RCMessage {
        static var isShowTime = "kIsShowTime"
        static var cellHeight = "kCellHeight"
        static var cellWidth  = "kCellWidth"
    }
    
    /// 消息显示文本
    var text: String? {
        switch self.objectName {
        case RCTextMessage.getObjectName():
            return (self.content as? RCTextMessage)?.content
        case RCRichContentMessage.getObjectName():
            return (self.content as? RCRichContentMessage)?.title
        default:
            return nil
        }
    }
    
    // 用户扩展字段
    var userInfo: KFUserModel? {
        guard let _id = self.senderUserId?.intValue else {
            return nil
        }
        self.sentStatus = .SentStatus_FAILED
//        let userInfo = BPDBCenter.share.selectUserInfo(userId: _id)
        return userInfo
    }
    
    var isShowTime: Bool {
        set {
            objc_setAssociatedObject(self, &RCMessage.isShowTime, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            objc_getAssociatedObject(self, &RCMessage.isShowTime) as? Bool ?? false
        }
    }
    
    /// 缓存聊天室bubble的高度
    var bubbleHeight: CGFloat? {
        set {
            guard let _newValue = newValue else { return }
//            objc_setAssociatedObject(self, &RCMessage.cellHeight, NSNumber(value: Float(_newValue)), .OBJC_ASSOCIATION_COPY)
            var dict = extra?.convertToDictionary() ?? [:]
            dict["bubbleHeight"] = _newValue
            let dictStr = dict.toJson()
            extra = dictStr
            RCIMClient.shared().setMessageExtra(self.messageId, value: dictStr)
        }
        
        get {
//            guard let heightFloat = objc_getAssociatedObject(self, &RCMessage.cellHeight) as? Float else {
//                return nil
//            }
//            return CGFloat(heightFloat)
            
            guard let _heightFloat = extra?.convertToDictionary()["bubbleHeight"] as?  CGFloat else {
                return nil
            }
            return CGFloat(_heightFloat)
        }
    }
    
    /// 缓存聊天室bubble的宽度（小灰条）
    var bubbleWidth: CGFloat? {
        set {
            guard let _newValue = newValue else { return }
//            objc_setAssociatedObject(self, &RCMessage.cellWidth, NSNumber(value: Float(_newValue)), .OBJC_ASSOCIATION_COPY)
            var dict = extra?.convertToDictionary() ?? [:]
            dict["bubbleWidth"] = _newValue
            let dictStr = dict.toJson()
            extra = dictStr
            RCIMClient.shared().setMessageExtra(self.messageId, value: dictStr)
        }
        
        get {
//            guard let widthFloat = objc_getAssociatedObject(self, &RCMessage.cellWidth) as? Float else {
//                return nil
//            }
//            return CGFloat(widthFloat)
            guard let _widthFloat = extra?.convertToDictionary()["bubbleWidth"] as?  CGFloat else {
                return nil
            }
            return CGFloat(_widthFloat)
        }
    }
    
    /// 时间，更具发送和接收类型展示
    var time: Date? {
        if self.messageDirection == .MessageDirection_SEND {
            let time = TimeInterval(integerLiteral: self.sentTime)/1000
            return Date(timeIntervalSince1970: time)
        } else {
            let time = TimeInterval(integerLiteral: self.receivedTime)/1000
            return Date(timeIntervalSince1970: time)
        }
    }
    
    /// 更新是否显示时间戳状态
    func updateShowTimeStatus(lastMessageTime: Date?) {
        if let _lastTime = lastMessageTime {
            if (time?.timeIntervalSince(_lastTime).minute() ?? 0) >= 3 {
                self.isShowTime = true
            } else {
                self.isShowTime = false
            }
        } else {
            self.isShowTime = true
        }
    }
}

