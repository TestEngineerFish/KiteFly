//
//  KFHomeMemberListCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import UIKit
import STYKit

class KFHomeMemberListCell: TYTableViewCell_ty {
    
    private var model: KFUserModel?
    
    private var avatarImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius  = AdaptSize_ty(5)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var nameLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.semibold_ty(AdaptSize_ty(15))
        label.textAlignment = .left
        return label
    }()
    private var sexLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regular_ty(AdaptSize_ty(15))
        label.textAlignment = .left
        return label
    }()
    private var remarkLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regular_ty(AdaptSize_ty(13))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private var chatButton: TYButton_ty = {
        let button = TYButton_ty(.second_ty)
        button.setTitle("去聊天", for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(13))
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.contentView.addSubview(avatarImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(sexLabel)
        self.contentView.addSubview(remarkLabel)
        self.contentView.addSubview(chatButton)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.setLine_ty()
        self.chatButton.addTarget(self, action: #selector(chatAction), for: .touchUpInside)
    }
    
    override func updateConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.top.equalToSuperview().offset(AdaptSize_ty(15))
            make.size.equalTo(CGSize(width: AdaptSize_ty(60), height: AdaptSize_ty(60)))
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize_ty(10))
            make.right.equalTo(chatButton.snp.left).offset(AdaptSize_ty(-5))
            make.top.equalTo(avatarImageView)
        }
        sexLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize_ty(5))
        }
        remarkLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView)
            make.right.equalTo(chatButton)
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptSize_ty(10))
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-10))
        }
        chatButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(60), height: AdaptSize_ty(35)))
            make.centerY.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
        }
        super.updateConstraints()
    }

    // MARK: ==== Event ====
    func setData(model: KFUserModel) {
        self.model = model
        self.avatarImageView.setImage_ty(imageStr_ty: model.avatar)
        self.nameLabel.text   = model.name
        self.sexLabel.text    = "性别：\(model.sex.str)"
        self.remarkLabel.text = "简介：\(model.remark)"
    }
    
    @objc
    private func chatAction() {
        let vc = KFChatRoomViewController()
        vc.userModel = model
        currentNVC_ty?.push_ty(vc_ty: vc)
    }
}
