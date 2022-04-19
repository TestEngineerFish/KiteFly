//
//  BPEmojiCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/18.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit
import STYKit

protocol KFEmojiCellDelegate: NSObjectProtocol {
    func selectedEmoji(model: KFEmojiModel)
}

class KFEmojiCell: TYCollectionViewCell_ty {

    weak var delegate: KFEmojiCellDelegate?
    var emojiModel: KFEmojiModel?

    private var emojiButton: TYButton_ty = {
        let button = TYButton_ty()
        button.imageEdgeInsets = UIEdgeInsets(top: AdaptSize_ty(10), left: AdaptSize_ty(10), bottom: AdaptSize_ty(10), right: AdaptSize_ty(10))
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func createSubviews_ty() {
        self.addSubview(emojiButton)
        emojiButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    internal override func bindProperty_ty() {
        self.emojiButton.addTarget(self, action: #selector(clickButtonAction(sender:)), for: .touchUpInside)
    }
    
    override func updateUI_ty() {
        super.updateUI_ty()
        self.backgroundColor = .clear
    }

    // MARK: ==== Event ====
    func setData(emoji model: KFEmojiModel) {
        self.emojiModel = model
        self.emojiButton.setImage(model.image, for: .normal)
    }

    @objc private func clickButtonAction(sender: TYButton_ty) {
        guard let model = self.emojiModel else {
            return
        }
        self.delegate?.selectedEmoji(model: model)
    }
}
