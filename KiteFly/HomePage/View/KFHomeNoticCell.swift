//
//  KFHomeNoticCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation

class KFHomeNoticCell: KFTableViewCell {
    
    private var customContentView: KFView = {
        let view = KFView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = AdaptSize(5)
        view.layer.setDefaultShadow()
        return view
    }()
    
    private var logoImageView: KFImageView = {
        let imageView = KFImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.size = CGSize(width: kScreenWidth - AdaptSize(20), height: AdaptSize(180))
        imageView.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(5))
        return imageView
    }()
    
    private var titleLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptSize(20))
        label.textAlignment = .left
        return label
    }()
    private var amountLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    private var contactLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    private var addressLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.black
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        return label
    }()
    private var registerButton: KFButton = {
        let button = KFButton(.second)
        button.setTitle("去报名", for: .normal)
        button.isUserInteractionEnabled = false
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.mediumFont(ofSize: AdaptSize(16))
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
        self.updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.contentView.addSubview(customContentView)
        customContentView.addSubview(logoImageView)
        customContentView.addSubview(titleLabel)
        customContentView.addSubview(amountLabel)
        customContentView.addSubview(contactLabel)
        customContentView.addSubview(addressLabel)
        customContentView.addSubview(registerButton)
        
        customContentView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(AdaptSize(10))
            make.right.bottom.equalToSuperview().offset(AdaptSize(-10))
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(logoImageView.size)
        }
        addressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(40))
            make.top.equalTo(logoImageView.snp.bottom)
        }
        contactLabel.snp.makeConstraints { make in
            make.left.right.equalTo(addressLabel)
            make.height.equalTo(contactLabel.font.lineHeight)
            make.bottom.equalTo(addressLabel.snp.top).offset(AdaptSize(-15))
        }
        amountLabel.snp.makeConstraints { make in
            make.left.right.equalTo(addressLabel)
            make.height.equalTo(amountLabel.font.lineHeight)
            make.bottom.equalTo(contactLabel.snp.top).offset(AdaptSize(-10))
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(titleLabel.font.lineHeight)
            make.top.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        registerButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(80), height: AdaptSize(30)))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.bottom.equalTo(logoImageView).offset(AdaptSize(-15))
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
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    // MARK: ==== Event ====
    func setData(model: KFNoticeModel) {
        self.logoImageView.setImage(with: model.icon)
        self.amountLabel.text  = "报名人数: \(model.userModelList.count) 人"
        self.contactLabel.text = "联系电话: \(model.contact)"
        self.addressLabel.text = "地址: \(model.address)"
        self.titleLabel.text   = model.title
    }
}
