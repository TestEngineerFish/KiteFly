//
//  BPChatRoomMessageImageCell.swift
//  MessageCenter
//
//  Created by apple on 2021/12/17.
//  Copyright © 2021 KLC. All rights reserved.
//

import Foundation
import RongIMLib
import STYKit

class KFChatRoomMessageImageCell: KFChatRoomMessageCell {
    
    private let maxImageHeight = AdaptSize_ty(240)
    private let maxImageWidth  = AdaptSize_ty(195)
    private var imageSize: CGSize = .zero
    
    var contentImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius  = AdaptSize_ty(8)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.bubbleView.addSubview(contentImageView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.bubbleView.backgroundImageView.isHidden = true
    }
    
    // MARK: ==== Event ====
    override func setBubbleView() {
        super.setBubbleView()
        guard let messageModel = self.messageModel, let imageMessage = messageModel.content as? RCImageMessage else {
            return
        }

        // 获取图片大小
        self.imageSize = CGSize(width: maxImageWidth, height: maxImageHeight)
        // 设置图片
        var cacheName: String?
        if messageModel.messageDirection == .MessageDirection_SEND {
            cacheName = imageMessage.localPath
        } else {
            cacheName = imageMessage.remoteUrl
        }
        if let imageData = TYFileManager_ty.share_ty.getSessionMedia_ty(type_ty: .sessionImage_ty, name_ty: imageMessage.localPath, sessionId_ty: messageModel.targetId, userId_ty: messageModel.targetId) {
            self.contentImageView.image = UIImage(data: imageData)
            self.updateImageSize()
        }
        
//        self.contentImageView.setImage_ty(imageStr_ty: imageMessage.remoteUrl, cacheName: cacheName, sessionId: self.messageModel?.targetId) {  [weak self] (image: UIImage?) in
//            guard let self = self else { return }
//            if self.imageSize == .zero {
//                self.updateImageSize()
//            }
//        }
    }
    
    private func updateImageSize() {
        var _size = self.imageSize
        if _size == .zero {
            _size = self.contentImageView.image?.size ?? .zero
        }

        if _size.height > _size.width {
            // 长图
            if _size.height > self.maxImageHeight {
                let scale  = _size.height / self.maxImageHeight
                let _width = _size.width / scale
                _size      = CGSize(width: _width, height: self.maxImageHeight)
            } else {
                let scale  = _size.height / self.maxImageHeight
                let _width = _size.width * scale
                _size      = CGSize(width: _width, height: _size.height)
            }
        } else {
            // 宽图
            if _size.width > self.maxImageWidth {
                let scale   = _size.width / self.maxImageWidth
                let _height = _size.height / scale
                _size       = CGSize(width: self.maxImageWidth, height: _height)
            } else {
                let scale   = _size.width / self.maxImageWidth
                let _height = _size.height * scale
                _size       = CGSize(width: _size.width, height: _height)
            }
        }
        self.contentImageView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.equalTo(_size)
        }
        if let indexPath = self.indexPath, let model = self.messageModel {
            self.delegate?.updateCellSize(size: _size, model: model, indexPath: indexPath)
        }
    }
}
