//
//  KFCommunityRemarkCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation

protocol KFCommunityRemarkCellDelegate: NSObjectProtocol {
    /// 回复评论
    func replyRemarkAction(model: KFCommunityRemarkModel)
    /// 举报评论
    func reportAction(model: KFCommunityRemarkModel)
}

class KFCommunityRemarkCell: BPTableViewCell {
    
    private var model: KFCommunityRemarkModel?
    weak var delegate: KFCommunityRemarkCellDelegate?
    
    private var customContentView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = AdaptSize(5)
        view.layer.setDefaultShadow()
        return view
    }()
    private var avatarImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.size = CGSize(width: AdaptSize(30), height: AdaptSize(30))
        imageView.layer.cornerRadius  = AdaptSize(15)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var moreButton: BPButton = {
        let button = BPButton()
        button.setImage(UIImage(named: "more_remark"), for: .normal)
        return button
    }()
    private var nameLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.semiboldFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        return label
    }()
    private var timeLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .right
        return label
    }()
    private var contentLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
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
        self.contentView.addSubview(customContentView)
        customContentView.addSubview(avatarImageView)
        customContentView.addSubview(moreButton)
        customContentView.addSubview(nameLabel)
        customContentView.addSubview(timeLabel)
        customContentView.addSubview(contentLabel)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .clear
        self.moreButton.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
    }
    
    override func updateConstraints() {
        customContentView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(AdaptSize(15))
            make.right.bottom.equalToSuperview().offset(AdaptSize(-15))
        }
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(avatarImageView.size)
            make.left.top.equalTo(AdaptSize(15))
        }
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(50), height: AdaptSize(40)))
            make.right.equalToSuperview().offset(AdaptSize(-5))
            make.top.equalToSuperview().offset(5)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize(10))
            make.centerY.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptSize(10))
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(AdaptSize(15))
            make.left.right.equalTo(contentLabel)
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFCommunityRemarkModel) {
        self.model = model
        self.avatarImageView.setImage(with: model.byUser?.avatar)
        self.nameLabel.text     = model.byUser?.name
        self.contentLabel.text  = model.content
        self.timeLabel.text     = model.createTime?.timeStr()
    }
    
    @objc
    private func moreAction() {
        guard let _model = model else { return }
        BPActionSheet().addItem(title: "回复") {
            self.delegate?.replyRemarkAction(model: _model)
        }.addItem(title: "举报") {
            self.delegate?.reportAction(model: _model)
        }.show()
    }
}
