//
//  KFSettingUserHeaderView.swift
//  KiteFly
//
//  Created by apple on 2022/4/2.
//

import Foundation
import STYKit

class KFSettingUserHeaderView: TYView_ty {
    
    private var model: KFUserModel?
    
    private var avatarImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode         = .scaleAspectFill
        imageView.size_ty                = CGSize(width: AdaptSize_ty(80), height: AdaptSize_ty(80))
        imageView.layer.cornerRadius  = AdaptSize_ty(40)
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
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
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(clickAvatarAction))
        self.avatarImageView.addGestureRecognizer(tapGes)
    }
    
    override func updateConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(avatarImageView.size_ty)
            make.top.equalToSuperview().offset(AdaptSize_ty(20))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-10))
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFUserModel?) {
        self.model = model
        self.avatarImageView.setImage_ty(imageStr_ty: model?.avatar)
    }
    
    @objc
    private func clickAvatarAction() {
        guard let _model = self.model, _model.id == KFUserModel.share.id else {
            return
        }
        
        TYPhotoManager_ty.share_ty.show_ty { modelList in
            guard let imageModel = modelList.first as? TYMediaImageModel_ty else {
                return
            }
            self.avatarImageView.image = imageModel.image_ty
        }
    }
}

