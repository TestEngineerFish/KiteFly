//
//  BPChatRoomMessageTextCell.swift
//  MessageCenter
//
//  Created by apple on 2021/12/17.
//  Copyright © 2021 KLC. All rights reserved.
//

import Foundation
import RongIMLib

class KFChatRoomMessageTextCell: KFChatRoomMessageCell {
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.bubbleView.addSubview(messageLabel)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.bubbleView.backgroundImageView.isHidden = false
    }
    
    // MARK: ==== Event ====
    override func setBubbleView() {
        super.setBubbleView()
        guard let messageModel = self.messageModel else { return }
        // 设置属性
        if messageModel.messageDirection == .MessageDirection_SEND {
            self.bubbleView.setRightGreenBackground()
            self.messageLabel.textColor = .white
        } else {
            self.bubbleView.setLeftWhiteBackground()
            self.messageLabel.textColor = .black2
        }
        // 更新文案
        let attrStr = messageModel.text?.convertToCommonEmations(font: self.messageLabel.font, color: self.messageLabel.textColor)
        self.messageLabel.attributedText = attrStr
        
        var labelSize: CGSize?
        // 缓存设置高度
        if let _bubbleHeight = messageModel.bubbleHeight, let _bubbleWidth = messageModel.bubbleWidth {
            labelSize = CGSize(width: _bubbleWidth - AdaptSize(25), height: _bubbleHeight - (topSpace + -bottomSpace))
        } else {
            // 无缓存内容则更新高度
            labelSize = self.messageLabel.sizeThatFits(CGSize(width: self.bubbleView.maxWidth - AdaptSize(25), height: CGFloat.greatestFiniteMagnitude))
            if let indexPath = self.indexPath {
                let _bubbleSize = CGSize(width: labelSize!.width + AdaptSize(25), height: labelSize!.height + (topSpace + -bottomSpace))
                print("== 总：\(_bubbleSize)")
                self.delegate?.updateCellSize(size: _bubbleSize, model: messageModel, indexPath: indexPath)
            }
        }
        if let _labelSize = labelSize {
            // 设置布局
            self.messageLabel.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(topSpace)
                make.width.equalTo(_labelSize.width)
                make.bottom.equalToSuperview().offset(bottomSpace)
                if messageModel.messageDirection == .MessageDirection_SEND {
                    make.left.equalToSuperview().offset(AdaptSize(10))
                    make.right.equalToSuperview().offset(AdaptSize(-15))
                } else {
                    make.left.equalToSuperview().offset(AdaptSize(15))
                    make.right.equalToSuperview().offset(AdaptSize(-10))
                }
            }
        }
    }
}
