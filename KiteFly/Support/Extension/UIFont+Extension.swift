//
//  UIFont+Extension.swift
//  BPCommon
//
//  Created by 沙庭宇 on 2021/10/22.
//

import UIKit

/**
 *  IconFont
 */
public extension UIFont {
    class func iconFont(size: CGFloat) -> UIFont? {
        let font = UIFont(name: "iconfont", size: size)
        return font
    }
}


public extension UIFont {

    /// 常用字体
    private struct FontFamilyName {
        static let PingFangTCRegular  = "PingFangSC-Regular"
        static let PingFangTCMedium   = "PingFangSC-Medium"
        static let PingFangTCSemibold = "PingFangSC-Semibold"
        static let PingFangTCLight    = "PingFangSC-Light"
        static let DINAlternateBold   = "DINAlternate-Bold"
    }
    
    class func regularFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: FontFamilyName.PingFangTCRegular, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize:size)
        }
    }
    
    class func mediumFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: FontFamilyName.PingFangTCMedium, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize:size)
        }
    }
    
    class func semiboldFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: FontFamilyName.PingFangTCSemibold, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize:size)
        }
    }
    
    class func lightFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: FontFamilyName.PingFangTCLight, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize:size)
        }
    }
    
    class func DINAlternateBold(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: FontFamilyName.DINAlternateBold, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize:size)
        }
    }
}
