//
//  BPEmojiToolView.swift
//  BaseProject
//  Emoji表情选择页面
//  Created by 沙庭宇 on 2020/11/18.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

protocol BPEmojiToolViewDelegate: NSObjectProtocol {
    /// 选择表情
    func selectedEmoji(model: BPEmojiModel)
    /// 删除
    func deleteActionWithEmoji()
    /// 发送
    func sendActionWithEmoji()
}

class BPEmojiToolView: BPView, UICollectionViewDelegate, UICollectionViewDataSource, BPEmojiCellDelegate {

    let cellID         = "kBPEmojiCell"
    var emojiModelList = [BPEmojiModel]()

    weak var delegate: BPEmojiToolViewDelegate?

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let w = kScreenWidth / 7
        layout.itemSize                = CGSize(width: w, height: w)
        layout.scrollDirection         = .vertical
        layout.minimumLineSpacing      = .zero
        layout.minimumInteritemSpacing = .zero
        layout.footerReferenceSize = CGSize(width: kScreenWidth, height: AdaptSize(40))
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var deleteButton: BPButton = {
        let button = BPButton(.second)
        button.setTitle("删除", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        button.layer.setDefaultShadow()
        return button
    }()

    private var sendButton: BPButton = {
        let button = BPButton(.theme)
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        button.layer.setDefaultShadow()
        return button
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
        self.addSubview(collectionView)
        self.addSubview(deleteButton)
        self.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().offset(AdaptSize(-5))
            make.width.equalTo(AdaptSize(50))
            make.height.equalTo(AdaptSize(30))
        }
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(sendButton.snp.left).offset(AdaptSize(-10))
            make.bottom.equalTo(sendButton)
            make.width.equalTo(AdaptSize(50))
            make.height.equalTo(AdaptSize(30))
        }
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(BPEmojiCell.classForCoder(), forCellWithReuseIdentifier: cellID)
        self.deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        self.sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
    }
    
    override func updateUI() {
        super.updateUI()
        self.deleteButton.setTitleColor(UIColor.black0, for: .normal)
        self.deleteButton.backgroundColor = UIColor.white
        self.backgroundColor              = UIColor.white
    }

    override func bindData() {
        super.bindData()
        let assetUrl = Bundle.main.bundleURL.appendingPathComponent("emoji.bundle")
        guard let contents = try? FileManager.default.contentsOfDirectory(at: assetUrl, includingPropertiesForKeys: [.nameKey], options: .skipsHiddenFiles) else {
            return
        }
        for item in contents {
            var emojiName    = item.lastPathComponent
            if emojiName.hasSuffix(".png") {
                emojiName = emojiName.substring(fromIndex: 0, length: emojiName.count - 4)
            }
            let imagePath    = "emoji.bundle/" + emojiName
            let emojiImage   = UIImage(named: imagePath)
            var emojiModel   = BPEmojiModel()
            emojiModel.name  = emojiName
            emojiModel.image = emojiImage
            self.emojiModelList.append(emojiModel)
        }
        self.collectionView.reloadData()
    }
    
    func show() {
        self.isHidden = false
        if self.emojiModelList.isEmpty {
            self.bindData()
        }
    }
    
    func hide() {
        self.isHidden = true
    }
    
    // MARK: ==== Event ====
    @objc
    private func deleteAction() {
        self.delegate?.deleteActionWithEmoji()
    }
    
    @objc
    private func sendAction() {
        self.delegate?.sendActionWithEmoji()
    }

    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.emojiModelList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? BPEmojiCell else {
            return BPCollectionViewCell()
        }
        let emojiModel = self.emojiModelList[indexPath.row]
        cell.setData(emoji: emojiModel)
        cell.delegate = self
        return cell
    }

    // MARK: ==== BPEmojiCellDelegate ====
    func selectedEmoji(model: BPEmojiModel) {
        self.delegate?.selectedEmoji(model: model)
    }
}
