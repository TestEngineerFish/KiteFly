//
//  RCHQVoiceMessage+Extension.swift
//  MessageCenter
//
//  Created by apple on 2021/11/16.
//  Copyright © 2021 KLC. All rights reserved.
//

import Foundation
import RongIMLib

extension RCHQVoiceMessage {
    
    private struct AudioMessage {
        static var isPlaying = "isPlaying"
    }
    
    /// 是否在播放中
    var isPlaying: Bool {
        get {
            return objc_getAssociatedObject(self, &AudioMessage.isPlaying) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &AudioMessage.isPlaying, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
