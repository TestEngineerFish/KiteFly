//
//  BPChatRoomMessageCellStatusView.swift
//  MessageCenter
//
//  Created by apple on 2021/11/18.
//  Copyright © 2021 KLC. All rights reserved.
//

import Foundation
import UIKit

enum BPMessageStatusType: Int {
    case normal  = 0
    case unread  = 1
    case fail    = 2
    case loading = 3
}

class BPChatRoomMessageCellStatusView: BPView {
    
    var type: BPMessageStatusType = .normal
    
    /// 未读
    private var redDotView: BPRedDotView = {
        let view = BPRedDotView(showNumber: false, colorType: .red)
        view.isHidden = true
        return view
    }()
    /// 发送失败
    private var failImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image       = UIImage(named: "message_sendfail")
        imageView.isHidden    = true
        imageView.size        = CGSize(width: AdaptSize(18), height: AdaptSize(18))
        return imageView
    }()
    private var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.isHidden = true
        return view
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
        self.addSubview(redDotView)
        self.addSubview(failImageView)
        self.addSubview(loadingView)
        redDotView.snp.makeConstraints { make in
            make.size.equalTo(redDotView.size)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        failImageView.snp.makeConstraints { make in
            make.size.equalTo(failImageView.size)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        loadingView.snp.makeConstraints { make in
            make.size.equalTo(loadingView.size)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
    }
    
    // MARK: ==== Event ====
    func setStatus(type: BPMessageStatusType) {
        self.type = type
        DispatchQueue.main.async {
            self.loadingView.stopAnimating()
            switch type {
            case .normal:
                self.redDotView.isHidden    = true
                self.failImageView.isHidden = true
                self.loadingView.isHidden   = true
            case .unread:
                self.redDotView.isHidden    = false
                self.failImageView.isHidden = true
                self.loadingView.isHidden   = true
            case .fail:
                self.redDotView.isHidden    = true
                self.failImageView.isHidden = false
                self.loadingView.isHidden   = true
            case .loading:
                self.redDotView.isHidden    = true
                self.failImageView.isHidden = true
                self.loadingView.isHidden   = false
                self.loadingView.startAnimating()
            }
        }
    }
}

