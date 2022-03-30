//
//  BPTableViewCell.swift
//  BPKit
//
//  Created by samsha on 2021/6/28.
//

import UIKit
import ObjectMapper

private struct AssociatedKeys {
    static var lineView: String = "kLineView"
}

open class BPTableViewCell: UITableViewCell {
    
    open var viewClickedBlock: IndexPathBlock?
    open var longPressBlock: IndexPathBlock?
    open var indexPath: IndexPath?
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.updateUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化子视图
    open func createSubviews() {}
    
    /// 初始化属性
    open func bindProperty() {
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: kScreenWidth, bottom: 0, right: 0)
    }
    
    /// 初始化数据
    /// - Parameters:
    ///   - model: 数据模型
    ///   - indexPath: 下标
    open func bindData(model: Mappable, indexPath: IndexPath) {}
    
    /// 更新UI颜色、图片
    open func updateUI() {}
    
    ///  添加通知
    open func registerNotification() {}
    
    /// 设置底部分割线
    /// - Parameters:
    ///   - left: 距左边距离
    ///   - right: 距右边距离
    public func setLine(isHide: Bool = false, left: CGFloat = AdaptSize(15), right: CGFloat = .zero) {
        // 追加属性
        if let lineView = objc_getAssociatedObject(self, &AssociatedKeys.lineView) as? UIView {
            lineView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(left)
                make.right.equalToSuperview().offset(right)
            }
            lineView.isHidden = isHide
        } else {
            let lineView = BPView()
            lineView.backgroundColor = UIColor.gray
            contentView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(left)
                make.right.equalToSuperview().offset(right)
                make.bottom.equalToSuperview()
                make.height.equalTo(0.5)
            }
            lineView.isHidden = isHide
            objc_setAssociatedObject(self, &AssociatedKeys.lineView, lineView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    ///
}
