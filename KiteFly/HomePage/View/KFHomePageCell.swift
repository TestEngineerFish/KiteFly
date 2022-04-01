//
//  KFHomePageCell.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation
import UIKit

class KFHomePageCell: BPCollectionViewCell {
    
    private var titleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        label.layer.setDefaultShadow()
        return label
    }()
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
        self.contentView.addSubview(titleLabel)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
            make.right.equalToSuperview().offset(AdaptSize(-15))
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
        self.titleLabel.text = model.title
    }
}
