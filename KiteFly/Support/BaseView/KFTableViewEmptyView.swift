//
//  KFTableViewEmptyView.swift
//  BPKit
//
//  Created by samsha on 2021/7/8.
//

import UIKit

class KFTableViewEmptyView: KFView {
        
    private var contentView: KFView = {
        let view = KFView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private var imageView: KFImageView = {
        let imageView = KFImageView()
        imageView.contentMode     = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private var hintLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.semiboldFont(ofSize: AdaptSize(16))
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ==== KFViewDelegate ====
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(hintLabel)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(84), height: AdaptSize(84)))
        }
        hintLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(imageView.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(hintLabel.font.lineHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .clear
    }
    
    // MARK: ==== Event ====
    func setData(image: UIImage?, hintText: String?) {
        if let _image = image {
            self.imageView.image = _image
        } else {
            // 默认图
            self.imageView.image = UIImage(named: "defalut_empty_icon")
        }
        if let _hintText = hintText {
            self.hintLabel.text = _hintText
        } else {
            // 默认文案
            self.hintLabel.text = "暂无数据"
        }
    }
}

