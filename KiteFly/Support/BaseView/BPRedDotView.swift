//
//  BPRedDotView.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/1/7.
//

import UIKit

public enum KFRedDotViewEnum {
    /// 红色背景
    case red
    /// 灰色背景
    case gray
    
    var backgroundColor: UIColor {
        switch self {
        case .red:
            return UIColor.red0
        case .gray:
            return UIColor.gray1
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .red:
            return UIColor.white
        case .gray:
            return UIColor.black0
        }
    }
}

public class BPRedDotView: KFView {

    private var showNumber: Bool
    private let maxNumber: Int   = 99
    private var defaultH:CGFloat = .zero
    private var colorType: KFRedDotViewEnum = .red
    
    private let numLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.font          = UIFont.regularFont(ofSize: AdaptSize(10))
        label.textAlignment = .center
        return label
    }()
    
    /// 是否显示未读数，false则显示红点
    /// - Parameter showNumber: 未读数量
    public init(showNumber: Bool = false, colorType: KFRedDotViewEnum = .red) {
        self.colorType  = colorType
        self.showNumber = showNumber
        super.init(frame: .zero)
        if showNumber {
            defaultH = AdaptSize(16)
        } else {
            // 小圆点
            defaultH = AdaptSize(6)
            self.size = CGSize(width: defaultH, height: defaultH)
        }
        self.createSubviews()
        self.bindProperty()
        self.updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        if showNumber {
            self.addSubview(self.numLabel)
            self.numLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    public override func bindProperty() {
        super.bindProperty()
        self.isUserInteractionEnabled = false
        self.layer.cornerRadius = defaultH/2
        if showNumber {
            self.layer.borderColor  = UIColor.white.cgColor
            self.layer.borderWidth  = 1
        }
    }
    
    public override func updateUI() {
        super.updateUI()
        self.backgroundColor    = colorType.backgroundColor
        self.numLabel.textColor = colorType.titleColor
    }
    
    // MARK: ==== Event ====
    public func updateNumber(_ num: Int) {
        let value          = self.getNumberStr(num: num)
        self.numLabel.text = value
        self.isHidden      = num <= 0
        // update layout
        if self.superview != nil {
            var w = defaultH
            if (num > 9 || num < 0) {
                w = value.textWidth(font: numLabel.font, height: defaultH) + AdaptSize(10)
            }
            self.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize(width: w, height: defaultH))
            }
        }
    }
    
    // TODO: ==== Tools ====
    public func getNumberStr(num: Int) -> String {
        return num > maxNumber ? "\(maxNumber)+" : "\(num)"
    }
    
}
