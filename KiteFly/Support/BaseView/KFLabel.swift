//
//  KFLabel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

open class KFLabel: UILabel {
    /// 内边距
    public var textInsets: UIEdgeInsets?
    
    public override func drawText(in rect: CGRect) {
        guard let insets = self.textInsets else {
            return super.drawText(in: rect)
        }
        super.drawText(in: rect.inset(by: insets))
    }
    
    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard let insets = self.textInsets, let _ = self.text else {
            return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        }
        var rect = super.textRect(forBounds: bounds.inset(by: insets),
                                  limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= insets.left
        rect.origin.y    -= insets.top
        rect.size.width  += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
    
    /// 设置文本，指定行间距
    public func setText(text: String, line space: CGFloat) {
        self.text = text
        let style = NSMutableParagraphStyle()
        style.lineSpacing   = space
        style.lineBreakMode = self.lineBreakMode
        style.alignment     = self.textAlignment
        let attr = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle : style])
        self.attributedText = attr
    }
}
