//
//  KFSettingHeaderView.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation

class KFSettingHeaderView: BPView {
    
    private var avatarImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode         = .scaleAspectFill
        imageView.size                = CGSize(width: AdaptSize(60), height: AdaptSize(60))
        imageView.layer.cornerRadius  = AdaptSize(30)
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
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        return label
    }()
    private var remarkLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
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
        self.addSubview(remarkLabel)
    }
    
    override func bindProperty() {
        super.bindProperty()
    }
    
    override func updateConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(avatarImageView.size)
            make.left.top.equalToSuperview().offset(AdaptSize(15))
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
        remarkLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView)
            make.right.equalTo(nameLabel)
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptSize(10))
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFUserModel) {
        self.avatarImageView.setImage(with: model.avatar)
        self.nameLabel.text   = model.name
        self.sexLabel.text    = model.sex.str
        self.remarkLabel.text = model.remark
    }
}

