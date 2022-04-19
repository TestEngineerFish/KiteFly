//
//  KFHomeNewsItem.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation
import STYKit

class KFHomeNewsItem: TYCollectionViewCell_ty {
    
    private var customContentView: TYView_ty = {
        let view = TYView_ty()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = AdaptSize_ty(5)
        view.layer.setDefaultShadow_ty()
        return view
    }()
    
    private var iconImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = AdaptSize_ty(10)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var titleLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black
        label.font          = UIFont.regular_ty(AdaptSize_ty(14))
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
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
        self.contentView.addSubview(customContentView)
        customContentView.addSubview(iconImageView)
        customContentView.addSubview(titleLabel)
        customContentView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(AdaptSize_ty(10))
            make.bottom.right.equalToSuperview().offset(AdaptSize_ty(-10))
        }
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(260), height: AdaptSize_ty(260)))
            make.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-10))
        }
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func updateUI_ty() {
        super.updateUI_ty()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFNewsModel) {
        self.iconImageView.setImage_ty(imageStr_ty: model.icon)
        self.titleLabel.text = model.title
    }
}

