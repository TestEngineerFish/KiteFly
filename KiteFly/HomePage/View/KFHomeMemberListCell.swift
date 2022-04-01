//
//  KFHomeMemberListCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import UIKit

class KFHomeMemberListCell: BPTableViewCell {
    
    private var model: KFUserModel?
    
    private var avatarImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius  = AdaptSize(5)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var nameLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.semiboldFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        return label
    }()
    private var sexLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        return label
    }()
    private var remarkLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private var chatButton: BPButton = {
        let button = BPButton(.second)
        button.setTitle("去聊天", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
        self.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.contentView.addSubview(avatarImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(sexLabel)
        self.contentView.addSubview(remarkLabel)
        self.contentView.addSubview(chatButton)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.setLine()
        self.chatButton.addTarget(self, action: #selector(chatAction), for: .touchUpInside)
    }
    
    override func updateConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.top.equalToSuperview().offset(AdaptSize(15))
            make.size.equalTo(CGSize(width: AdaptSize(60), height: AdaptSize(60)))
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize(10))
            make.right.equalTo(chatButton.snp.left).offset(AdaptSize(-5))
            make.top.equalTo(avatarImageView)
        }
        sexLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize(5))
        }
        remarkLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView)
            make.right.equalTo(chatButton)
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptSize(10))
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
        }
        chatButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(60), height: AdaptSize(35)))
            make.centerY.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        super.updateConstraints()
    }

    // MARK: ==== Event ====
    func setData(model: KFUserModel) {
        self.model = model
        self.avatarImageView.setImage(with: model.avatar)
        self.nameLabel.text   = model.name
        self.sexLabel.text    = "性别：\(model.sex.str)"
        self.remarkLabel.text = "简介：\(model.remark)"
    }
    
    @objc
    private func chatAction() {
        let vc = BPChatRoomViewController()
        vc.userModel = model
        UIViewController.currentNavigationController?.push(vc: vc)
    }
}
