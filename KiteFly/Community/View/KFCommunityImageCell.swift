//
//  KFCommunityImageCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation


class KFCommunityImageCell: KFCollectionViewCell {
    
    private var imageView: KFImageView = {
        let imageView = KFImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds      = true
        imageView.isUserInteractionEnabled = true
        return imageView
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
        self.contentView.addSubview(imageView)
    }
    
    override func bindProperty() {
        super.bindProperty()
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(clickImage))
        self.imageView.addGestureRecognizer(tapGes)
    }
    
    override func updateConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(image url: String) {
        self.imageView.setImage(with: url)
    }
    
    func setImage(image: UIImage?) {
        if let _image = image {
            self.imageView.image = _image
        } else {
            self.imageView.image = UIImage(named: "emptyImage")
        }
    }
    
    @objc
    private func clickImage() {
        guard let _image = self.imageView.image else {
            return
        }
        let model = BPMediaImageModel()
        model.image = _image
        KFBrowserView(type: .custom(modelList: [model]), current: 0).show(animationView: self.imageView)
    }
}
