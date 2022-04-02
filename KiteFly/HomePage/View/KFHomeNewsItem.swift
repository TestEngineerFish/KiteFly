//
//  KFHomeNewsItem.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation

class KFHomeNewsItem: KFCollectionViewCell {
    
    private var customContentView: KFView = {
        let view = KFView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = AdaptSize(5)
        view.layer.setDefaultShadow()
        return view
    }()
    
    private var iconImageView: KFImageView = {
        let imageView = KFImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = AdaptSize(10)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var titleLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.black
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.contentView.addSubview(customContentView)
        customContentView.addSubview(iconImageView)
        customContentView.addSubview(titleLabel)
        customContentView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(AdaptSize(10))
            make.bottom.right.equalToSuperview().offset(AdaptSize(-10))
        }
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(60), height: AdaptSize(60)))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(15))
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(AdaptSize(10))
            make.right.equalToSuperview().offset(AdaptSize(-10))
            make.top.bottom.equalTo(iconImageView)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func updateUI() {
        super.updateUI()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFNewsModel) {
        self.iconImageView.setImage(with: model.icon)
        self.titleLabel.text = model.title
    }
}

