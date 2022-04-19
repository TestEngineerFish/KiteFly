//
//  BPChatMoreView.swift
//  MessageCenter
//
//  Created by apple on 2022/1/20.
//

import Foundation
import STYKit

protocol KFChatMoreViewDelegate: NSObjectProtocol {
    func clickCommonWordsItemAction()
    func clickVideoItemAction()
    func clickImageItemAction()
    func clickGiftItemAction()
}

class KFChatMoreView: TYView_ty {
    
    weak var delegate: KFChatMoreViewDelegate?
    
    /// 常用语
    private var commonWordsButton: TYButton_ty = {
        let button = TYButton_ty()
        button.size_ty = CGSize(width: AdaptSize_ty(50), height: AdaptSize_ty(50))
        button.setImage(UIImage(named: "chat_tools_commonWords"), for: .normal)
        return button
    }()
    
    /// 音视频
    private var videoButton: TYButton_ty = {
        let button = TYButton_ty()
        button.size_ty = CGSize(width: AdaptSize_ty(50), height: AdaptSize_ty(50))
        button.setImage(UIImage(named: "chat_tools_video"), for: .normal)
        return button
    }()
    
    /// 照片
    private var imageButton: TYButton_ty = {
        let button = TYButton_ty()
        button.size_ty = CGSize(width: AdaptSize_ty(50), height: AdaptSize_ty(50))
        button.setImage(UIImage(named: "chat_tools_image"), for: .normal)
        return button
    }()
    
    /// 礼物
    private var giftButton: TYButton_ty = {
        let button = TYButton_ty()
        button.size_ty = CGSize(width: AdaptSize_ty(50), height: AdaptSize_ty(50))
        button.setImage(UIImage(named: "chat_tools_gift"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        let stackView = TYStackView_ty(type_ty: .center, subview_ty: [commonWordsButton, videoButton, imageButton, giftButton], spacing_ty: AdaptSize_ty(32))
        stackView.backgroundColor = .clear
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize_ty(50))
            make.top.equalToSuperview().offset(AdaptSize_ty(12))
        }
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.commonWordsButton.addTarget(self, action: #selector(clickCommonWordsItemAction), for: .touchUpInside)
        self.videoButton.addTarget(self, action: #selector(clickVideoItemAction), for: .touchUpInside)
        self.imageButton.addTarget(self, action: #selector(clickImageItemAction), for: .touchUpInside)
        self.giftButton.addTarget(self, action: #selector(clickGiftItemAction), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
    
    @objc
    private func clickCommonWordsItemAction() {
        self.delegate?.clickCommonWordsItemAction()
    }
    
    @objc
    private func clickVideoItemAction() {
        self.delegate?.clickVideoItemAction()
    }
    
    @objc
    private func clickImageItemAction() {
        self.delegate?.clickImageItemAction()
    }
    
    @objc
    private func clickGiftItemAction() {
        self.delegate?.clickGiftItemAction()
    }
}

