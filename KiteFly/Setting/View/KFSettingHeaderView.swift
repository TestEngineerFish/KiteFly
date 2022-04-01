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
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private var nameLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.semiboldFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    private var sexLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    private var addressLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    private var remarkLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    private var lineView: BPView = {
        let view = BPView()
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
        let tapAvatarGes = UITapGestureRecognizer(target: self, action: #selector(clickAvatarAction))
        let tapNameGes = UITapGestureRecognizer(target: self, action: #selector(clickNameAction))
        let tapSexGes = UITapGestureRecognizer(target: self, action: #selector(clickSexAction))
        let tapAddressGes = UITapGestureRecognizer(target: self, action: #selector(clickAddressAction))
        let tapRemarkGes = UITapGestureRecognizer(target: self, action: #selector(clickRemarkAction))
        
        self.avatarImageView.addGestureRecognizer(tapAvatarGes)
        self.nameLabel.addGestureRecognizer(tapNameGes)
        self.sexLabel.addGestureRecognizer(tapSexGes)
        self.addressLabel.addGestureRecognizer(tapAddressGes)
        self.remarkLabel.addGestureRecognizer(tapRemarkGes)
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
        addressLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(sexLabel.snp.bottom).offset(AdaptSize(5))
        }
        remarkLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView)
            make.right.equalTo(nameLabel)
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptSize(20))
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
        self.remarkLabel.text  = model.remark
    }
    
    @objc
    private func clickAvatarAction() {
        BPSystemPhotoManager.share.show { modelList in
            guard let imageModel = modelList.first as? BPMediaImageModel else {
                return
            }
            self.avatarImageView.image = imageModel.image
        }
    }
    
    @objc
    private func clickNameAction() {
        let vc = KFSettingRenameViewController()
        vc.type = .name
        UIViewController.currentNavigationController?.push(vc: vc)
    }
    
    @objc
    private func clickSexAction() {
        BPActionSheet(title: "选择性别").addItem(title: "男") {
            KFUserModel.share.sex = .man
            self.sexLabel.text = KFUserModel.share.sex.str
        }.addItem(title: "女") {
            KFUserModel.share.sex = .woman
            self.sexLabel.text = KFUserModel.share.sex.str
        }.addItem(title: "保密") {
            KFUserModel.share.sex = .unknown
            self.sexLabel.text = KFUserModel.share.sex.str
        }.show()
    }
    
    @objc
    private func clickAddressAction() {
        let vc = KFSettingRenameViewController()
        vc.type = .address
        UIViewController.currentNavigationController?.push(vc: vc)
    }
    
    @objc
    private func clickRemarkAction() {
        let vc = KFSettingRenameViewController()
        vc.type = .remark
        UIViewController.currentNavigationController?.push(vc: vc)
    }
}

