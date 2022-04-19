//
//  KFSettingCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import STYKit

class KFSettingCell: TYTableViewCell_ty {
    
    private var iconImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var titleLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regular_ty(AdaptSize_ty(15))
        label.textAlignment = .left
        return label
    }()
    private var arrowImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(arrowImageView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
    }
    
    override func updateConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize_ty(25), height: AdaptSize_ty(25)))
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(AdaptSize_ty(15))
            make.right.equalTo(arrowImageView.snp.left).offset(AdaptSize_ty(-15))
            make.centerY.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize_ty(15), height: AdaptSize_ty(15)))
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    
    func setData(type: KFSettingType) {
        self.iconImageView.image  = type.icon
        self.titleLabel.text      = type.rawValue
        self.arrowImageView.image = UIImage(named: "arrow_right")
    }
}
