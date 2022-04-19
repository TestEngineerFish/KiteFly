//
//  KFSettingNoticeCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import UIKit
import STYKit

protocol KFSettingNoticeCellDelegate: NSObject {
    // 评论
    func remarkAction(model: KFCommunityModel)
}

class KFSettingNoticeCell: TYTableViewCell_ty, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let cellID: String = "kKFCommunityImageCell"
    private var imageList = [String]()
    private var model: KFCommunityModel?
    weak var delegate: KFSettingNoticeCellDelegate?
    
    private var customContentView: TYView_ty = {
        let view = TYView_ty()
        view.backgroundColor    = UIColor.white
        view.layer.cornerRadius = AdaptSize_ty(8)
        view.layer.setDefaultShadow_ty()
        return view
    }()
    private var avatarImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFill
        imageView.size_ty = CGSize(width: AdaptSize_ty(60), height: AdaptSize_ty(60))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = AdaptSize_ty(30)
        return imageView
    }()
    private var nameLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.semibold_ty(AdaptSize_ty(15))
        label.textAlignment = .left
        return label
    }()
    private var addressLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regular_ty(AdaptSize_ty(13))
        label.textAlignment = .left
        return label
    }()
    private var contentLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regular_ty(AdaptSize_ty(15))
        label.textAlignment = .left
        return label
    }()
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize                 = CGSize(width: AdaptSize_ty(80), height: AdaptSize_ty(80))
        layout.scrollDirection          = .vertical
        layout.minimumLineSpacing       = AdaptSize_ty(10)
        layout.minimumInteritemSpacing  = AdaptSize_ty(10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    private var remarkButton: TYButton_ty = {
        let button = TYButton_ty()
        button.setTitle("评论", for: .normal)
        button.setTitleColor(UIColor.black0, for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(13))
        return button
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
        customContentView.addSubview(nameLabel)
        customContentView.addSubview(addressLabel)
        customContentView.addSubview(remarkButton)
        customContentView.addSubview(contentLabel)
        customContentView.addSubview(collectionView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(KFCommunityImageCell.classForCoder(), forCellWithReuseIdentifier: cellID)
        self.remarkButton.addTarget(self, action: #selector(remarkAction), for: .touchUpInside)
    }
    
    override func updateConstraints() {
        customContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.top.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-15))
        }
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(avatarImageView.size_ty)
            make.top.left.equalToSuperview().offset(AdaptSize_ty(15))
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize_ty(10))
            make.top.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(AdaptSize_ty(-10))
        }
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize_ty(5))
        }
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptSize_ty(15))
        }
        collectionView.snp.remakeConstraints { make in
            make.left.right.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(AdaptSize_ty(15))
            if imageList.isEmpty {
                make.height.equalTo(0)
            } else {
                let isRound = imageList.count % 3 > 0
                var line    = imageList.count/3
                line        = isRound ? line + 1 : line
                let h       = CGFloat(line) * AdaptSize_ty(90) - AdaptSize_ty(10)
                make.height.equalTo(h)
            }
        }
        remarkButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(60), height: AdaptSize_ty(35)))
            make.top.equalTo(collectionView.snp.bottom).offset(AdaptSize_ty(10))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-10))
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFCommunityModel) {
        self.model = model
        if let userModel = model.userModel {
            self.avatarImageView.setImage_ty(imageStr_ty: userModel.avatar)
            self.nameLabel.text    = userModel.name
            self.addressLabel.text = userModel.address
        }
        self.contentLabel.text = model.content
        self.imageList = model.imageList
        self.updateConstraints()
        self.collectionView.reloadData()
    }
    
    @objc
    private func remarkAction() {
        guard let _model = self.model else {
            return
        }
        self.delegate?.remarkAction(model: _model)
    }
    
    
    // MARK: ==== UICollectionViewDelegate, UICollectionViewDataSource ====
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? KFCommunityImageCell else {
            return UICollectionViewCell()
        }
        let url = self.imageList[indexPath.row]
        cell.setData(image: url)
        return cell
    }
}
