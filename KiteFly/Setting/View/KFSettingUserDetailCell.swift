//
//  KFSettingUserDetailCell.swift
//  KiteFly
//
//  Created by apple on 2022/4/2.
//

import Foundation

class KFSettingUserDetailCell: KFTableViewCell {
    
    private var iconImageView: KFImageView = {
        let imageView = KFImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var titleLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        return label
    }()
    private var contentLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    private var arrowImageView: KFImageView = {
        let imageView = KFImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image       = UIImage(named: "arrow_right")
        return imageView
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
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(arrowImageView)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.setLine()
    }
    
    override func updateConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(AdaptSize(25))
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(AdaptSize(10))
            make.centerY.equalTo(iconImageView)
            make.width.equalTo(AdaptSize(100))
        }
        contentLabel.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(AdaptSize(5))
            make.right.equalTo(arrowImageView.snp.left).offset(AdaptSize(-5))
            make.top.equalToSuperview().offset(AdaptSize(15))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
        }
        arrowImageView.snp.makeConstraints { make in
            make.width.height.equalTo(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
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
