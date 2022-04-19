//
//  KFCommunityRemarkCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import STYKit

protocol KFCommunityRemarkCellDelegate: NSObjectProtocol {
    /// 回复评论
    func replyRemarkAction(model: KFCommunityRemarkModel)
    /// 举报评论
    func reportRemarkAction(model: KFCommunityRemarkModel)
}

class KFCommunityRemarkCell: TYTableViewCell_ty {
    
    private var model: KFCommunityRemarkModel?
    weak var delegate: KFCommunityRemarkCellDelegate?
    
    private var customContentView: TYView_ty = {
        let view = TYView_ty()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = AdaptSize_ty(5)
        view.layer.setDefaultShadow_ty()
        return view
    }()
    private var avatarImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFill
        imageView.size_ty = CGSize(width: AdaptSize_ty(30), height: AdaptSize_ty(30))
        imageView.layer.cornerRadius  = AdaptSize_ty(15)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var moreButton: TYButton_ty = {
        let button = TYButton_ty()
        button.setImage(UIImage(named: "more_remark"), for: .normal)
        return button
    }()
    private var nameLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.semibold_ty(AdaptSize_ty(15))
        label.textAlignment = .left
        return label
    }()
    private var timeLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regular_ty(AdaptSize_ty(13))
        label.textAlignment = .right
        return label
    }()
    private var contentLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regular_ty(AdaptSize_ty(15))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
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
        self.contentView.addSubview(customContentView)
        customContentView.addSubview(avatarImageView)
        customContentView.addSubview(moreButton)
        customContentView.addSubview(nameLabel)
        customContentView.addSubview(timeLabel)
        customContentView.addSubview(contentLabel)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.backgroundColor = .clear
        self.moreButton.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
    }
    
    override func updateConstraints() {
        customContentView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.bottom.equalToSuperview().offset(AdaptSize_ty(-15))
        }
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(avatarImageView.size_ty)
            make.left.top.equalTo(AdaptSize_ty(15))
        }
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(50), height: AdaptSize_ty(40)))
            make.right.equalToSuperview().offset(AdaptSize_ty(-5))
            make.top.equalToSuperview().offset(5)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize_ty(10))
            make.centerY.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
        }
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptSize_ty(10))
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(AdaptSize_ty(15))
            make.left.right.equalTo(contentLabel)
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-15))
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFCommunityRemarkModel) {
        self.model = model
        self.avatarImageView.setImage_ty(imageStr_ty: model.byUser?.avatar)
        self.nameLabel.text     = model.byUser?.name
        self.contentLabel.text  = model.content
        self.timeLabel.text     = model.createTime?.timeStr_ty()
    }
    
    @objc
    private func moreAction() {
        guard let _model = model else { return }
        TYActionSheet_ty().addItem_ty(title_ty: "回复") {
            self.delegate?.replyRemarkAction(model: _model)
        }.addItem_ty(title_ty: "举报") {
            self.delegate?.reportRemarkAction(model: _model)
        }.show_ty()
    }
}
