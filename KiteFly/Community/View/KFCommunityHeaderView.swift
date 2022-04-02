//
//  KFCommunityHeaderView.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation

protocol KFCommunityHeaderViewDelegate: NSObject {
    func reportAction(model: KFCommunityModel)
    func clickAvatarAction(model: KFUserModel)
}

class KFCommunityHeaderView: BPView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let cellID: String = "kKFCommunityImageCell"
    private var imageList = [String]()
    private var model: KFCommunityModel?
    weak var delegate: KFCommunityHeaderViewDelegate?
    
    private var customContentView: BPView = {
        let view = BPView()
        view.backgroundColor    = UIColor.white
        view.layer.cornerRadius = AdaptSize(8)
        view.layer.setDefaultShadow()
        return view
    }()
    private var avatarImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.size = CGSize(width: AdaptSize(60), height: AdaptSize(60))
        imageView.layer.masksToBounds       = true
        imageView.layer.cornerRadius        = AdaptSize(30)
        imageView.isUserInteractionEnabled  = true
        return imageView
    }()
    private var nameLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.semiboldFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private var addressLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
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
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize                 = CGSize(width: AdaptSize(80), height: AdaptSize(80))
        layout.scrollDirection          = .vertical
        layout.minimumLineSpacing       = AdaptSize(10)
        layout.minimumInteritemSpacing  = AdaptSize(10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    private var reportButton: BPButton = {
        let button = BPButton()
        button.setImage(UIImage(named: "report"), for: .normal)
        button.setTitle("举报", for: .normal)
        button.setTitleColor(UIColor.black0, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()
    private var remarkButton: BPButton = {
        let button = BPButton()
//        button.setImage(UIImage(named: "remark"), for: .normal)
        button.setTitle("评论", for: .normal)
        button.setTitleColor(UIColor.black0, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(customContentView)
        customContentView.addSubview(avatarImageView)
        customContentView.addSubview(nameLabel)
        customContentView.addSubview(addressLabel)
        customContentView.addSubview(reportButton)
        customContentView.addSubview(remarkButton)
        customContentView.addSubview(contentLabel)
        customContentView.addSubview(collectionView)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(KFCommunityImageCell.classForCoder(), forCellWithReuseIdentifier: cellID)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(clickAvatarAction))
        self.avatarImageView.addGestureRecognizer(tapGes)
    }
    
    override func updateConstraints() {
        customContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.top.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
        }
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(avatarImageView.size)
            make.top.left.equalToSuperview().offset(AdaptSize(15))
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize(10))
            make.top.equalTo(avatarImageView)
            make.right.equalTo(reportButton.snp.left).offset(AdaptSize(-10))
        }
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize(5))
        }
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptSize(15))
        }
        collectionView.snp.remakeConstraints { make in
            make.left.right.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(AdaptSize(15))
            if imageList.isEmpty {
                make.height.equalTo(0)
            } else if imageList.count == 1 {
                make.height.equalTo(kScreenWidth - AdaptSize(80))
            }  else {
                let isRound = imageList.count % 3 > 0
                var line    = imageList.count/3
                line        = isRound ? line + 1 : line
                let h       = CGFloat(line) * AdaptSize(90) - AdaptSize(10)
                make.height.equalTo(h)
            }
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
        }
        reportButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(15), height: AdaptSize(15)))
            make.top.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFCommunityModel) {
        self.model = model
        if let userModel = model.userModel {
            self.avatarImageView.setImage(with: userModel.avatar)
            self.nameLabel.text    = userModel.name
            self.addressLabel.text = userModel.address
        }
        self.contentLabel.text = model.content
        self.imageList = model.imageList
        self.updateConstraints()
        self.collectionView.reloadData()
    }
    
    @objc
    private func reportAction() {
        guard let _model = self.model else {
            return
        }
        self.delegate?.reportAction(model: _model)
    }
    
    @objc
    private func clickAvatarAction() {
        guard let _model = self.model?.userModel else { return }
        self.delegate?.clickAvatarAction(model: _model)
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
    
    // MARK: ==== UICollectionViewDelegateFlowLayout ====
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.imageList.count == 1 {
            return CGSize(width: kScreenWidth - AdaptSize(80), height: kScreenWidth - AdaptSize(80))
        } else {
            return CGSize(width: AdaptSize(80), height: AdaptSize(80))
        }
    }
}

