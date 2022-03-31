//
//  UILabel+Extension.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/22.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

public extension UILabel {
    /// 根据字体和画布宽度,计算文字在画布上的高度
    /// - parameter font: 字体
    /// - parameter width: 限制的宽度
    func textHeight(width: CGFloat) -> CGFloat {
        guard let _text = self.text, let _font = self.font else { return .zero}
        let rect = NSString(string: _text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: _font], context: nil)
        return ceil(rect.height)
    }
    
    /// 设置左侧 icon
    /// - Parameter icon: 图片
    func setIcon(icon: UIImage?, iconSize: CGSize? = nil) {
        guard let _icon = icon else {
            return
        }
        let _iconSize = iconSize ?? CGSize(width: AdaptSize(7), height: AdaptSize(7))
        let attachment = NSTextAttachment()
        attachment.image = _icon
        let offsetY = font.lineHeight/2 - _iconSize.height
        attachment.bounds = CGRect(origin: CGPoint(x: 0, y: offsetY), size: _iconSize)
        let mAttr = NSMutableAttributedString(attachment: attachment)
        mAttr.append(NSAttributedString(string: " " + (self.text ?? "")))
        self.attributedText = mAttr
    }
    
    /// 设置显示必选图标
    func setRequiredIcon() {
        //        let icon = getImage(name: "bp_required_icon", type: "png")
        //        self.setIcon(icon: icon)
    }
    
    /// 显示默认阴影
    func showShadow() {
        self.layer.shadowOffset       = CGSize(width: 1, height: 1)
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shadowRadius       = layer.cornerRadius
        self.layer.shadowOpacity      = 1.0
    }
    
    /// 隐藏阴影
    func hideShadow() {
        self.layer.shadowOffset  = .zero
        self.layer.shadowOpacity = .zero
    }
    
    /// 内容是否被截断（未展示完成，以[...]的方式展示）
    ///  需要展示后才可以计算
    var isTruncated: Bool {
        guard let labelText = text else {
            return false
        }
        
        //计算理论上显示所有文字需要的尺寸
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelTextSize = (labelText as NSString)
            .boundingRect(with: rect, options: .usesLineFragmentOrigin,
                          attributes: [.font: font as Any], context: nil)
        
        //计算理论上需要的行数
        let labelTextLines = Int(ceil(CGFloat(labelTextSize.height) / self.font.lineHeight))
        
        //实际可显示的行数
        var labelShowLines = Int(floor(CGFloat(bounds.size.height) / self.font.lineHeight))
        if self.numberOfLines != 0 {
            labelShowLines = min(labelShowLines, self.numberOfLines)
        }
        
        //比较两个行数来判断是否需要截断
        return labelTextLines > labelShowLines
    }
    
    /// 计算行数
    /// - Parameter width: 最大宽度
    /// - Returns: 最终行数
    func numberLines(width: CGFloat) -> Int {
        let maxSize = CGSize(width: width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = NSString(string: self.text ?? "")
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil)
        let lines = Int(textSize.height/charSize)
        return lines
    }
}
