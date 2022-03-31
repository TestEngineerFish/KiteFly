//
//  KFCommunityImageCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation


class KFCommunityImageCell: BPCollectionViewCell {
    
    private var imageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
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
}
