//
//  BPChatRoomMessageCellStatusView.swift
//  MessageCenter
//
//  Created by apple on 2021/11/18.
//  Copyright © 2021 KLC. All rights reserved.
//

import Foundation
import UIKit
import STYKit

enum KFMessageStatusType: Int {
    case normal  = 0
    case unread  = 1
    case fail    = 2
    case loading = 3
}

class KFChatRoomMessageCellStatusView: TYView_ty {
    
    var type: KFMessageStatusType = .normal
    
    /// 未读
    private var redDotView: TYRedDotView_ty = {
        let view = TYRedDotView_ty(showNumber_ty: false, colorType_ty: .red_ty)
        view.isHidden = true
        return view
    }()
    /// 发送失败
    private var failImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFill
        imageView.image       = UIImage(named: "message_sendfail")
        imageView.isHidden    = true
        imageView.size_ty        = CGSize(width: AdaptSize_ty(18), height: AdaptSize_ty(18))
        return imageView
    }()
    private var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.isHidden = true
        return view
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
        self.addSubview(redDotView)
        self.addSubview(failImageView)
        self.addSubview(loadingView)
        redDotView.snp.makeConstraints { make in
            make.size.equalTo(redDotView.size_ty)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        failImageView.snp.makeConstraints { make in
            make.size.equalTo(failImageView.size_ty)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        loadingView.snp.makeConstraints { make in
            make.size.equalTo(loadingView.size_ty)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
    }
    
    // MARK: ==== Event ====
    func setStatus(type: KFMessageStatusType) {
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

