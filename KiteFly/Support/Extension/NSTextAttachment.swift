//
//  NSTextAttachment+Extension.swift
//  MessageCenter
//
//  Created by apple on 2021/10/28.
//  Copyright © 2021 KLC. All rights reserved.
//

import UIKit

public extension NSTextAttachment {
    
    private struct AssociatedKeys {
        static var name = "kNSTextAttachmentName"
    }
    
    /// 名称（暂用于表情名称）
    var name: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.name) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.name, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
