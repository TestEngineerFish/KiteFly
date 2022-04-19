//
//  KFSettingHeaderView.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import STYKit

class KFSettingHeaderView: TYView_ty {
    
    private var avatarImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode         = .scaleAspectFill
        imageView.size_ty                = CGSize(width: AdaptSize_ty(60), height: AdaptSize_ty(60))
        imageView.layer.cornerRadius  = AdaptSize_ty(30)
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private var nameLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.semibold_ty(AdaptSize_ty(15))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    private var sexLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black2
        label.font          = UIFont.regular_ty(AdaptSize_ty(13))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    private var addressLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black2
        label.font          = UIFont.regular_ty(AdaptSize_ty(13))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    private var remarkLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regular_ty(AdaptSize_ty(13))
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    private var lineView: TYView_ty = {
        let view = TYView_ty()
        view.backgroundColor = UIColor.gray4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        self.addSubview(sexLabel)
        self.addSubview(addressLabel)
        self.addSubview(remarkLabel)
        self.addSubview(lineView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
    }
    
    override func updateConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(avatarImageView.size_ty)
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.top.equalToSuperview().offset(AdaptSize_ty(30))
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize_ty(10))
            make.top.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
        }
        sexLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize_ty(5))
        }
        addressLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(sexLabel.snp.bottom).offset(AdaptSize_ty(5))
        }
        remarkLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView)
            make.right.equalTo(nameLabel)
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptSize_ty(30))
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(remarkLabel.snp.bottom).offset(AdaptSize_ty(15))
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize_ty(15))
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFUserModel) {
        self.avatarImageView.setImage_ty(imageStr_ty: model.avatar)
        self.nameLabel.text    = model.name
        self.sexLabel.text     = model.sex.str
        self.addressLabel.text = "地址：\(model.address)"
        self.remarkLabel.text  = "个性签名：\(model.remark)"
    }
}

