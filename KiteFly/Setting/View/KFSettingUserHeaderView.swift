//
//  KFSettingUserHeaderView.swift
//  KiteFly
//
//  Created by apple on 2022/4/2.
//

import Foundation

class KFSettingUserHeaderView: KFView {
    
    private var model: KFUserModel?
    
    private var avatarImageView: KFImageView = {
        let imageView = KFImageView()
        imageView.contentMode         = .scaleAspectFill
        imageView.size                = CGSize(width: AdaptSize(80), height: AdaptSize(80))
        imageView.layer.cornerRadius  = AdaptSize(40)
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
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
    }
    
    override func bindProperty() {
        super.bindProperty()
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(clickAvatarAction))
        self.avatarImageView.addGestureRecognizer(tapGes)
    }
    
    override func updateConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(avatarImageView.size)
            make.top.equalToSuperview().offset(AdaptSize(20))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFUserModel?) {
        self.model = model
        self.avatarImageView.setImage(with: model?.avatar)
    }
    
    @objc
    private func clickAvatarAction() {
        guard let _model = self.model, _model.id == KFUserModel.share.id else {
            return
        }
        KFSystemPhotoManager.share.show { modelList in
            guard let imageModel = modelList.first as? BPMediaImageModel else {
                return
            }
            self.avatarImageView.image = imageModel.image
        }
    }
}

