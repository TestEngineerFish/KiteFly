//
//  String+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import CommonCrypto
import STYKit

public extension String {

    /// 将文字中的表情符转换成表情显示
    func toEmoji(font: UIFont, color: UIColor) -> NSMutableAttributedString {
        let pattern = "\\[.{1,3}\\]"
        let textAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : color]

        let attrStr = NSMutableAttributedString(string: self, attributes: textAttributes)
        var regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        guard var matches = regex?.matches(in: self, options: .withoutAnchoringBounds, range: NSMakeRange(0, attrStr.string.count)), !matches.isEmpty else {
            return attrStr
        }

        matches.reverse()
        for result in matches {
            let range     = result.range
            let emojiStr  = (self as NSString).substring(with: range)
            let imagePath = "emoji.bundle/" + emojiStr + ".png"
            guard let emojiImage = UIImage(named: imagePath) else {
                continue
            }
            // 创建一个NSTextAttachment
            let attachment = NSTextAttachment()
            attachment.image     = emojiImage
            attachment.name_ty   = emojiStr
            let attachmentHeight = font.lineHeight
            let attachmentWidth  = attachmentHeight * emojiImage.size.width / emojiImage.size.height
            let offsetY          = (font.capHeight - font.lineHeight)/2
            attachment.bounds    = CGRect(x: 0, y: offsetY, width: attachmentWidth, height: attachmentHeight)
            let emojiAttr = NSAttributedString(attachment: attachment)
            attrStr.replaceCharacters(in: range, with: emojiAttr)
        }
        return attrStr
    }
}
