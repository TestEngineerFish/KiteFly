//
//  KFTableView.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/2/22.
//

import UIKit
import STYKit

public protocol KFTableViewIndexViewDelegate: NSObjectProtocol {
    func indexTitle(section: Int) -> String
}

open class KFTableView: UITableView {
    
    /// 是否隐藏默认空页面
    public var isHideEmptyView: Bool = false
    /// 为空占位图
    public var emptyImage: UIImage?
    /// 为空文案
    public var emptyHintText: String?

    private var currentSelectedIndex: Int = -1 {
        willSet {
            if currentSelectedIndex != newValue {
                if currentSelectedIndex < indexItemList.count && currentSelectedIndex >= 0 {
                    self.indexItemList[currentSelectedIndex].textColor = indexNormalColor
                }
                if newValue < indexItemList.count && newValue >= 0 {
                    self.indexItemList[newValue].textColor = indexSelectedColor
                }
            }
        }
    }
    private let itemW  = AdaptSize(30)
    private let itemH  = AdaptSize(20)
    private let guideW = AdaptSize(60)
    private let guideH = AdaptSize(60)
    /// 索引默认文字颜色
    private let indexNormalColor   = UIColor.black
    /// 索引选中颜色
    private let indexSelectedColor = UIColor.blue
    /// 索引回调代理
    public weak var indexDelegate: KFTableViewIndexViewDelegate?
    private var indexView: TYView_ty = {
        let view = TYView_ty()
        view.backgroundColor = UIColor.clear
        return view
    }()
    private var indexItemList: [UILabel] = []
    private var indexGuideLabel: UILabel = {
        let label = UILabel()
        label.text            = ""
        label.textColor       = UIColor.black
        label.font            = UIFont.regularFont(ofSize: AdaptSize(18))
        label.textAlignment   = .center
        label.isHidden        = true
        label.backgroundColor = UIColor.gray
        return label
    }()
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.updateUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    
    /// 更新UI颜色、图片
    open func updateUI() {}
    
    public override func reloadData() {
        super.reloadData()
        // 添加索引
        if indexDelegate != nil {
            self.createIndexView()
            self.addGestureAction()
            self.currentSelectedIndex = 0
        }
        // 配置空页面
        self.configEmptyView()
        // 结束加载动画
//        self.scrollEnd()
    }
    
    /// 配置默认空页面
    private func configEmptyView() {
        var rows      = 0
        let sesctions = numberOfSections
        for section in 0..<sesctions {
            rows += numberOfRows(inSection: section)
        }
        guard (rows == 0 && sesctions == 0) || (rows == 0 && sesctions == 1 && headerView(forSection: 0) == nil && footerView(forSection: 0) == nil) else {
            self.backgroundView = nil
            return
        }
        
        // 不隐藏则显示空视图
        if !self.isHideEmptyView {
            let emptyView = KFTableViewEmptyView()
            emptyView.setData(image: self.emptyImage, hintText: self.emptyHintText)
            self.backgroundView = emptyView
        }
    }

    // TODO: ==== IndexView ====
    private func createIndexView() {
        indexView.removeFromSuperview()
        guard let _superView = superview else { return }
        _superView.addSubview(indexView)
        _superView.addSubview(indexGuideLabel)
        var offsetY = CGFloat.zero
        self.indexItemList.removeAll()
        for section in 0..<self.numberOfSections {
            let label = KFLabel()
            label.tag             = section
            label.text            = self.indexDelegate?.indexTitle(section: section)
            label.textColor       = self.indexNormalColor
            label.font            = UIFont.regularFont(ofSize: AdaptSize(12))
            label.textAlignment   = .center
            label.isUserInteractionEnabled = true
            self.indexView.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.top.equalToSuperview().offset(offsetY)
                make.size.equalTo(CGSize(width: itemW, height: itemH))
            }
            self.indexItemList.append(label)
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(sender:)))
            label.addGestureRecognizer(tapGes)
            offsetY += itemH
        }
        indexView.snp.makeConstraints { (make) in
            make.right.equalTo(_superView)
            make.height.equalTo(offsetY)
            make.width.equalTo(itemW)
            make.centerY.equalToSuperview()
        }
    }

    /// 显示放大指示视图
    public func showIndexGuideView(section: Int) {
        indexGuideLabel.text     = self.indexDelegate?.indexTitle(section: section)
        indexGuideLabel.isHidden = false
        let offsetY = self.indexView.top + CGFloat(section) * itemH
        indexGuideLabel.frame = CGRect(x: kScreenWidth - itemW - guideW - AdaptSize(15), y: offsetY, width: guideW, height: guideH)
    }

    public func displayIndex(section: Int) {
        self.selectedIndexView(section: section, showGuideView: false, autoScroll: false)
    }

    private func addGestureAction() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(sender:)))
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(panAction(sender:)))
        self.indexView.addGestureRecognizer(tapGes)
        self.indexView.addGestureRecognizer(panGes)
    }

    // MARK: ==== Gesture Action ====
    @objc
    private func tapAction(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.indexView)
        let section  = Int(ceil(location.y / itemH)) - 1
        self.selectedIndexView(section: section, showGuideView: false, autoScroll: true)
        if sender.state == .ended || sender.state == .cancelled {
            self.indexGuideLabel.isHidden = true
        }
    }

    @objc
    private func panAction(sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let location = sender.location(in: self.indexView)
            let section  = Int(ceil(location.y / itemH)) - 1
            self.selectedIndexView(section: section, showGuideView: true, autoScroll: true)
        } else if sender.state == .ended || sender.state == .cancelled {
            self.indexGuideLabel.isHidden = true
        }
    }

    // MARK: ==== Event ====
    private func selectedIndexView(section: Int, showGuideView: Bool, autoScroll: Bool) {
        guard section != self.currentSelectedIndex, section < numberOfSections, section >= 0 else { return }
        self.currentSelectedIndex = section
        // 震动
        shake()
        if showGuideView {
            self.showIndexGuideView(section: section)
        }
        if autoScroll {
            self.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
        }
    }
}
