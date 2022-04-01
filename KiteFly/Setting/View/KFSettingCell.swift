//
//  KFSettingCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation

class KFSettingCell: BPTableViewCell {
    
    private var iconImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var titleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        return label
    }()
    private var arrowImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
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
        self.contentView.addSubview(arrowImageView)
    }
    
    override func bindProperty() {
        super.bindProperty()
    }
    
    override func updateConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(25), height: AdaptSize(25)))
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(AdaptSize(15))
            make.right.equalTo(arrowImageView.snp.left).offset(AdaptSize(-15))
            make.centerY.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(15), height: AdaptSize(15)))
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
