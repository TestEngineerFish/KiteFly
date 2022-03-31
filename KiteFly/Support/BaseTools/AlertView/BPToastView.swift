//
//  BPToastView.swift
//  MessageCenter
//
//  Created by apple on 2021/11/11.
//  Copyright © 2021 KLC. All rights reserved.
//

import UIKit

class BPToastView: BPView {
    
    private let maxWidth     = AdaptSize(230)
    private let defaultWidth = AdaptSize(120)
    private let defaultHight = AdaptSize(70)
    
    private var iconImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var descriptionLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.gray5
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(14))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        let _size = CGSize(width: defaultWidth, height: defaultHight)
        super.init(frame: CGRect(origin: CGPoint(x: (kScreenWidth - _size.width)/2, y: (kScreenHeight - _size.height)/2), size: _size))
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(iconImageView)
        self.addSubview(descriptionLabel)
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
            make.top.equalToSuperview().offset(AdaptSize(13))
            make.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(AdaptSize(7))
            make.left.equalToSuperview().offset(AdaptSize(5))
            make.right.equalToSuperview().offset(AdaptSize(-5))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .white
        self.layer.setDefaultShadow(alpha: 0.6)
    }
    
    // MARK: ==== Event ====
    
    /// 显示成功提示
    /// - Parameter text: 提示内容
    func showSuccess(text: String) {
        self.descriptionLabel.text = text
        self.iconImageView.image   = UIImage(named: "reset_success_icon")
        self.updateSize()
    }
    
    /// 显示错误提示
    /// - Parameter text: 提示内容
    func showFail(text: String) {
        self.descriptionLabel.text = text
        self.iconImageView.image   = UIImage(named: "common_icon_error")
        self.updateSize()
    }
    
    func showWarn(text: String) {
        self.descriptionLabel.text = text
        self.iconImageView.image   = UIImage(named: "common_icon_warning")
        self.updateSize()
    }
    
    // MARK: ==== Tools ====
    private func updateSize() {
        self.descriptionLabel.sizeToFit()
        var _width = self.descriptionLabel.width + AdaptSize(10)
        if _width > self.maxWidth {
            _width = self.maxWidth
        } else if _width < self.defaultWidth {
            _width = self.defaultWidth
        }
        let _size = self.descriptionLabel.sizeThatFits(CGSize(width: _width, height: CGFloat(Int.max)))
        self.size = CGSize(width: _size.width + AdaptSize(10), height: _size.height + AdaptSize(55))
        self.left = (kScreenWidth - self.width)/2
    }
}

