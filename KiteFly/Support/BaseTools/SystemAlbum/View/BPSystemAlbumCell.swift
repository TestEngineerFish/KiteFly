//
//  BPSystemAlbumCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/10.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

class BPSystemAlbumCell: UITableViewCell {

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        return label
    }()
    private var selectedImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image       = UIImage(named: "chat_photo_selected")
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(nameLabel)
        self.addSubview(selectedImageView)

        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalTo(selectedImageView.snp.left).offset(AdaptSize(-5))
            make.centerY.height.equalToSuperview()
        }
        selectedImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(16), height: AdaptSize(16)))
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
    }

    private func bindProperty() {
        self.selectionStyle = .none
    }

    func setData(model: BPPhotoAlbumModel, isCurrent: Bool) {
        self.nameLabel.text         = (model.assetCollection?.localizedTitle ?? "") + "(\(model.assets.count))"
        self.selectedImageView.isHidden = !isCurrent
    }
}
