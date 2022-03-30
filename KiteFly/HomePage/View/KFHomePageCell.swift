//
//  KFHomePageCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation

class KFHomePageCell: BPCollectionViewCell {
    
    private var imageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func setData(model: KFHomePageModel) {
        self.imageView.setImage(with: model.image)
    }
}
