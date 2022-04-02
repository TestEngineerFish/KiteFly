//
//  BPStackView.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/1/28.
//

import UIKit

public enum KFDirectionType: Int {
    case left
    case right
    case center
    case top
    case bottom
}

import Foundation

open class KFStackView: KFView {
    public var offsetX: CGFloat = .zero
    public var offsetY: CGFloat = .zero
    public var spacing: CGFloat
    private var type: KFDirectionType
    private var subviewList: [UIView]
    
    public init(type: KFDirectionType = .center, subview list: [UIView] = [], spacing: CGFloat = .zero) {
        self.type         = type
        self.subviewList  = list
        self.spacing      = spacing
        super.init(frame: .zero)
        self.updateUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func updateUI() {
        super.updateUI()
        self.backgroundColor = UIColor.clear
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard !subviewList.isEmpty else { return }
        switch type {
            case .left:
                offsetX = 0
                for subview in subviewList {
                    self.addSubview(subview)
                    subview.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().offset(offsetX)
                        make.centerY.equalToSuperview()
                        make.size.equalTo(subview.size)
                    }
                    offsetX += (subview.width + spacing)
                }
            case .center:
                offsetX = 0
                var residueW = self.width
                subviewList.forEach { (subview) in
                    residueW -= subview.width
                }
                if spacing.isZero {
                    // 未设置间距
                    self.spacing = residueW / CGFloat(subviewList.count - 1)
                } else {
                    // 固定间距
                    residueW -= CGFloat(subviewList.count - 1) * spacing
                    offsetX = residueW / 2
                }
                for subview in subviewList {
                    self.addSubview(subview)
                    subview.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().offset(offsetX)
                        make.centerY.equalToSuperview()
                        make.size.equalTo(subview.size)
                    }
                    offsetX += (subview.width + spacing)
                }
            case .right:
                offsetX = 0
                let _subviewList = subviewList.reversed()
                for subview in _subviewList {
                    self.addSubview(subview)
                    subview.snp.remakeConstraints { (make) in
                        make.right.equalToSuperview().offset(offsetX)
                        make.centerY.equalToSuperview()
                        make.size.equalTo(subview.size)
                    }
                    offsetX -= (subview.width + spacing)
                }
            case .top:
                offsetY = 0
                for subview in subviewList {
                    self.addSubview(subview)
                    subview.snp.remakeConstraints { (make) in
                        make.top.equalToSuperview().offset(offsetY)
                        make.centerX.equalToSuperview()
                        make.size.equalTo(subview.size)
                    }
                    offsetY += (subview.height + spacing)
                }
            default:
                break
        }
    }
    
    // MARK: ==== Event ====
    public func add(view: UIView) {
        self.subviewList.append(view)
        self.layoutSubviews()
    }
    
    public func insert(view: UIView, index: Int) {
        if index < 0 {
            self.subviewList = [view] + subviewList
        } else if index >= subviewList.count {
            self.subviewList.append(view)
        } else {
            self.subviewList.insert(view, at: index)
        }
        self.layoutSubviews()
    }
    
    public func remove(view: UIView) {
        for (index, subview) in subviewList.enumerated() {
            if subview == view {
                subview.removeFromSuperview()
                self.subviewList.remove(at: index)
                break
            }
        }
        self.layoutSubviews()
    }
    
    public func removeAll() {
        self.subviewList.forEach { (subview) in
            subview.removeFromSuperview()
        }
        self.subviewList = []
        offsetX = .zero
        offsetY = .zero
    }
}
