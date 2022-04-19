//
//  KFSettingUserDetailCell.swift
//  KiteFly
//
//  Created by apple on 2022/4/2.
//

import Foundation
import STYKit

class KFSettingUserDetailCell: TYTableViewCell_ty {
    
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
    private var contentLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regular_ty(AdaptSize_ty(15))
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    private var arrowImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFill
        imageView.image       = UIImage(named: "arrow_right")
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
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(arrowImageView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.setLine_ty()
    }
    
    override func updateConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(AdaptSize_ty(25))
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(AdaptSize_ty(10))
            make.centerY.equalTo(iconImageView)
            make.width.equalTo(AdaptSize_ty(100))
        }
        contentLabel.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(AdaptSize_ty(5))
            make.right.equalTo(arrowImageView.snp.left).offset(AdaptSize_ty(-5))
            make.top.equalToSuperview().offset(AdaptSize_ty(15))
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-15))
        }
        arrowImageView.snp.makeConstraints { make in
            make.width.height.equalTo(AdaptSize_ty(15))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.centerY.equalTo(iconImageView)
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(type: KFSettingType, model: KFUserModel?) {
        self.iconImageView.image    = type.icon
        self.titleLabel.text        = type.rawValue
        switch type {
        case .name:
            self.contentLabel.text = model?.name
        case .sex:
            self.contentLabel.text = model?.sex.str
        case .address:
            self.contentLabel.text = model?.address
        case .remark:
            self.contentLabel.text = model?.remark
        default:
            break
        }
    }
}
