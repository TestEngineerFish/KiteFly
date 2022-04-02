//
//  BPChatMoreView.swift
//  MessageCenter
//
//  Created by apple on 2022/1/20.
//

import Foundation

protocol KFChatMoreViewDelegate: NSObjectProtocol {
    func clickCommonWordsItemAction()
    func clickVideoItemAction()
    func clickImageItemAction()
    func clickGiftItemAction()
}

class KFChatMoreView: KFView {
    
    weak var delegate: KFChatMoreViewDelegate?
    
    /// 常用语
    private var commonWordsButton: KFButton = {
        let button = KFButton(size: CGSize(width: AdaptSize(50), height: AdaptSize(50)))
        button.setImage(UIImage(named: "chat_tools_commonWords"), for: .normal)
        return button
    }()
    
    /// 音视频
    private var videoButton: KFButton = {
        let button = KFButton(size: CGSize(width: AdaptSize(50), height: AdaptSize(50)))
        button.setImage(UIImage(named: "chat_tools_video"), for: .normal)
        return button
    }()
    
    /// 照片
    private var imageButton: KFButton = {
        let button = KFButton(size: CGSize(width: AdaptSize(50), height: AdaptSize(50)))
        button.setImage(UIImage(named: "chat_tools_image"), for: .normal)
        return button
    }()
    
    /// 礼物
    private var giftButton: KFButton = {
        let button = KFButton(size: CGSize(width: AdaptSize(50), height: AdaptSize(50)))
        button.setImage(UIImage(named: "chat_tools_gift"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        let stackView = KFStackView(type: .center, subview: [commonWordsButton, videoButton, imageButton, giftButton], spacing: AdaptSize(32))
        stackView.backgroundColor = .clear
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(50))
            make.top.equalToSuperview().offset(AdaptSize(12))
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
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

