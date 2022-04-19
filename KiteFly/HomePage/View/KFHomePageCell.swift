//
//  KFHomePageCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation
import UIKit
import STYKit

class KFHomePageCell: TYCollectionViewCell_ty {
    
    private var titleLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regular_ty(AdaptSize_ty(15))
        label.textAlignment = .left
        label.layer.setDefaultShadow_ty()
        return label
    }()
    private var imageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-10))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
        }
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFHomePageModel) {
        self.imageView.setImage_ty(imageStr_ty: model.image)
        self.titleLabel.text = model.title
    }
}
