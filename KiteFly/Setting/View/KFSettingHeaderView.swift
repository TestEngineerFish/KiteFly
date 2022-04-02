//
//  KFSettingHeaderView.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation

class KFSettingHeaderView: KFView {
    
    private var avatarImageView: KFImageView = {
        let imageView = KFImageView()
        imageView.contentMode         = .scaleAspectFill
        imageView.size                = CGSize(width: AdaptSize(60), height: AdaptSize(60))
        imageView.layer.cornerRadius  = AdaptSize(30)
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private var nameLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.semiboldFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    private var sexLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    private var addressLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    private var remarkLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    private var lineView: KFView = {
        let view = KFView()
        view.backgroundColor = UIColor.gray4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        self.addSubview(sexLabel)
        self.addSubview(addressLabel)
        self.addSubview(remarkLabel)
        self.addSubview(lineView)
    }
    
    override func bindProperty() {
        super.bindProperty()
    }
    
    override func updateConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(avatarImageView.size)
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.top.equalToSuperview().offset(AdaptSize(30))
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize(10))
            make.top.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        sexLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize(5))
        }
        addressLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(sexLabel.snp.bottom).offset(AdaptSize(5))
        }
        remarkLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView)
            make.right.equalTo(nameLabel)
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptSize(30))
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(remarkLabel.snp.bottom).offset(AdaptSize(15))
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(15))
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFUserModel) {
        self.avatarImageView.setImage(with: model.avatar)
        self.nameLabel.text    = model.name
        self.sexLabel.text     = model.sex.str
        self.addressLabel.text = "地址：\(model.address)"
        self.remarkLabel.text  = "个性签名：\(model.remark)"
    }
}

