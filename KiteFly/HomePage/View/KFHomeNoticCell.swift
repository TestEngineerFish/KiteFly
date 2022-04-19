//
//  KFHomeNoticCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation
import STYKit

class KFHomeNoticCell: TYTableViewCell_ty {
    
    private var customContentView: TYView_ty = {
        let view = TYView_ty()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = AdaptSize_ty(5)
        view.layer.setDefaultShadow_ty()
        return view
    }()
    
    private var logoImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFill
        imageView.size_ty = CGSize(width: kScreenWidth_ty - AdaptSize_ty(20), height: AdaptSize_ty(180))
        imageView.clipRectCorner_ty(directionList_ty: [.topLeft, .topRight], cornerRadius_ty: AdaptSize_ty(5))
        return imageView
    }()
    
    private var titleLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.DIN_ty(AdaptSize_ty(20))
        label.textAlignment = .left
        return label
    }()
    private var amountLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regular_ty(15)
        label.textAlignment = .left
        return label
    }()
    private var contactLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regular_ty(15)
        label.textAlignment = .left
        return label
    }()
    private var addressLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black
        label.font          = UIFont.medium_ty(AdaptSize_ty(16))
        label.textAlignment = .left
        return label
    }()
    private var registerButton: TYButton_ty = {
        let button = TYButton_ty(.second_ty)
        button.setTitle("去报名", for: .normal)
        button.isUserInteractionEnabled = false
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.medium_ty(AdaptSize_ty(16))
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.updateUI_ty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.contentView.addSubview(customContentView)
        customContentView.addSubview(logoImageView)
        customContentView.addSubview(titleLabel)
        customContentView.addSubview(amountLabel)
        customContentView.addSubview(contactLabel)
        customContentView.addSubview(addressLabel)
        customContentView.addSubview(registerButton)
        
        customContentView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(AdaptSize_ty(10))
            make.right.bottom.equalToSuperview().offset(AdaptSize_ty(-10))
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(logoImageView.size_ty)
        }
        addressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize_ty(40))
            make.top.equalTo(logoImageView.snp.bottom)
        }
        contactLabel.snp.makeConstraints { make in
            make.left.right.equalTo(addressLabel)
            make.height.equalTo(contactLabel.font.lineHeight)
            make.bottom.equalTo(addressLabel.snp.top).offset(AdaptSize_ty(-15))
        }
        amountLabel.snp.makeConstraints { make in
            make.left.right.equalTo(addressLabel)
            make.height.equalTo(amountLabel.font.lineHeight)
            make.bottom.equalTo(contactLabel.snp.top).offset(AdaptSize_ty(-10))
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(titleLabel.font.lineHeight)
            make.top.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
        }
        registerButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(80), height: AdaptSize_ty(30)))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.bottom.equalTo(logoImageView).offset(AdaptSize_ty(-15))
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
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    // MARK: ==== Event ====
    func setData(model: KFNoticeModel) {
        self.logoImageView.setImage_ty(imageStr_ty: model.icon)
        self.amountLabel.text  = "报名人数: \(model.userModelList.count) 人"
        self.contactLabel.text = "联系电话: \(model.contact)"
        self.addressLabel.text = "地址: \(model.address)"
        self.titleLabel.text   = model.title
    }
}
