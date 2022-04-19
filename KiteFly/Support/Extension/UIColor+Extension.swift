//
//  UIColor+Extension.swift
//  MessageCenter
//
//  Created by apple on 2021/10/28.
//  Copyright © 2021 KLC. All rights reserved.
//

import UIKit
import STYKit

//MARK: **************** 颜色值 **********************
public extension UIColor {
    // TODO: ====== Green ====

    /// 文字 (red: 34, green: 34, blue: 34)
    static let black0 = RGBA_ty(red_ty: 34, green_ty: 34, blue_ty: 34)
    /// 空页面提示 (red: 102, green: 102, blue: 102)
    static let black1 = RGBA_ty(red_ty: 102, green_ty: 102, blue_ty: 102)
    /// 单选文字 (red: 51, green: 51, blue: 51)
    static let black2 = RGBA_ty(red_ty: 51, green_ty: 51, blue_ty: 51)

    /// 分割线 (red: 249, green: 249, blue: 249)
    static let gray0 = RGBA_ty(red_ty: 249, green_ty: 249, blue_ty: 249)
    /// 文字 (red: 166, green: 166, blue: 166)
    static let gray1 = RGBA_ty(red_ty: 166, green_ty: 166, blue_ty: 166)
    /// 分割线 (red: 238, green: 238, blue: 238)
    static let gray4 = RGBA_ty(red_ty: 238, green_ty: 238, blue_ty: 238)

    /// 发送的消息 (red: 227, green: 0, blue: 0)
    static let green0 = RGBA_ty(red_ty: 28, green_ty: 221, blue_ty: 126)
    /// FFC42F
    static let theme = RGBA_ty(red_ty: 255, green_ty: 196, blue_ty: 47)
}
