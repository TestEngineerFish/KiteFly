//
//  BPCollectionViewCell.swift
//  BPKit
//
//  Created by samsha on 2021/7/14.
//

import Foundation

open class BPCollectionViewCell: UICollectionViewCell, BPViewDelegate {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    
    // MARK: ==== BPViewDelegate ====
    open func createSubviews() {}
    
    open func bindProperty() {}
    
    open func bindData() {}
    
    open func updateUI() {}
}
