//
//  KFCommunityImageCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import STYKit


class KFCommunityImageCell: TYCollectionViewCell_ty {
    
    private var imageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds      = true
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
        self.contentView.addSubview(imageView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(clickImage))
        self.imageView.addGestureRecognizer(tapGes)
    }
    
    override func updateConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(image url: String) {
        self.imageView.setImage_ty(imageStr_ty: url)
    }
    
    func setImage(image: UIImage?) {
        if let _image = image {
            self.imageView.image = _image
        } else {
            self.imageView.image = UIImage(named: "emptyImage")
        }
    }
    
    @objc
    private func clickImage() {
        guard let _image = self.imageView.image else {
            return
        }
        let model = TYMediaImageModel_ty()
        model.image_ty = _image
        TYBrowserView_ty(type_ty: .custom_ty(modelList_ty: [model]), current_ty: 0).show_ty(animationView_ty: self.imageView)
    }
}
