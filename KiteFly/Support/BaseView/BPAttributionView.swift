//
//  BPAttributionView.swift
//  Tenant
//
//  Created by samsha on 2021/1/27.
//

import UIKit
import CoreText

open class BPAttributionView: BPView {
    // 可配置的属性
    public var text: String {
        set {
            self.mAttrStr = NSMutableAttributedString(string: newValue)
            self.mAttrStr.addAttributes([NSAttributedString.Key.foregroundColor : textColor, NSAttributedString.Key.font : font], range: NSMakeRange(0, newValue.count))
            self.height = sizeForText(mAttrStr: mAttrStr, width: width).height
        }
        get {
            return mAttrStr.string
        }
    }
    public var font: UIFont = UIFont.regularFont(ofSize: AdaptSize(16)) {
        didSet {
            self.mAttrStr.addAttributes([NSAttributedString.Key.font : font], range: NSMakeRange(0, mAttrStr.length))
            self.height = sizeForText(mAttrStr: mAttrStr, width: width).height
        }
    }
    public var textColor = UIColor.gray0 {
        didSet {
            self.mAttrStr.addAttributes([NSAttributedString.Key.foregroundColor : textColor], range: NSMakeRange(0, mAttrStr.length))
        }
    }
    public var heightLightColor = UIColor.blue
    
    private var mAttrStr = NSMutableAttributedString(string: "")
    /// 点击中的范围（未点中，则为nil）
    private var tapRange: (NSRange,StringBlock?)?
    /// 符号条件的范围数组
    private var rangeList: [(NSRange,StringBlock?)] = []
    private var ctFrame: CTFrame?
    private var lineHeight: CGFloat = .zero
    
    /// 初始化函数
    /// - Parameter width: 最大宽度
    public init(width: CGFloat) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: .zero)))
        self.bindProperty()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 获得上下文
        let content = UIGraphicsGetCurrentContext()
        
        // 转换坐标
        content?.textMatrix = .identity
        content?.translateBy(x: 0, y: self.height)
        content?.scaleBy(x: 1.0, y: -1.0)
        
        // 绘制区域
        let path = UIBezierPath(rect: rect)
        
        // 设置Frame
        let framesetter = CTFramesetterCreateWithAttributedString(mAttrStr)
        ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mAttrStr.length), path.cgPath, nil)
        
        // 取出CTLine一行行绘制
        let lineList  = CTFrameGetLines(ctFrame!)
        let lineCount = CFArrayGetCount(lineList)
        
        var lineOriginList = Array(repeating: CGPoint.zero, count: lineCount)
        
        // 把Frame里的每一行的初始坐标写到数组里，注意CoreText的坐标是左下角为原点
        CTFrameGetLineOrigins(ctFrame!, CFRangeMake(0, 0), &lineOriginList)
        // 获取属性字所占的Size
        var frameY = CGFloat.zero
        // 计算每行的高度（总高度除以行数）
        self.lineHeight = height / CGFloat(lineCount)
        
        for index in 0..<lineCount {
            let line        = unsafeBitCast(CFArrayGetValueAtIndex(lineList, index), to: CTLine.self)
            var lineAscent  = CGFloat.zero
            var lineDescent = CGFloat.zero
            var leading     = CGFloat.zero
            // 该函数会自动设置好ascent、descent、leading，并返回该行的宽度
            CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &leading)
            
            var lineOrigin = lineOriginList[index]
            
            // 计算Y值
            frameY = height - CGFloat(index + 1)*lineHeight - font.descender
            // 这是Y值
            lineOrigin.y = frameY
            // 开始绘制
            content?.textPosition = lineOrigin
            CTLineDraw(line, content!)
            // 调整坐标
            frameY -= lineDescent
        }
    }
    
    open override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = UIColor.clear
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGes(ges:)))
        self.addGestureRecognizer(tapGes)
    }
    
    open override func gestureRecognizerShouldBegin(_ ges: UIGestureRecognizer) -> Bool {
        /// 防止与父控件其他手势冲突
        guard let tapGes = ges as? UITapGestureRecognizer else {
            return true
        }
        // 只有点中高亮区域才响应
        var response = false
        
        let location  = tapGes.location(in: self)
        let lineIndex = CFIndex(location.y/lineHeight)
        
        // 将点击坐标转换成CoreText坐标
        let clickPoint = CGPoint(x: location.x, y: lineHeight - location.y)
        let lineList   = CTFrameGetLines(self.ctFrame!)
        let lineCount  = CFArrayGetCount(lineList)
        if lineIndex < lineCount {
            let clickLine = unsafeBitCast(CFArrayGetValueAtIndex(lineList, lineIndex), to: CTLine.self)
            // 点击的index
            let startIndex = CTLineGetStringIndexForPosition(clickLine, clickPoint)
            for range in self.rangeList {
                if startIndex > range.0.location && startIndex < (range.0.location + range.0.length) {
                    response = true
                    self.tapRange = range
                }
            }
        }
        return response
    }
    
    // MARK: ==== Event ====
    @objc
    public func setHeightLightText(text: String, click block:StringBlock?) {
        let rangeList = self.getRangeList(regex: text)
        for range in rangeList {
            self.rangeList.append((range, block))
        }
        self.setHeightLight()
    }
    
    @objc
    private func tapGes(ges: UITapGestureRecognizer) {
        if ges.state == .ended, let range = self.tapRange {
            let tapStr = (text as NSString).substring(with: range.0)
            range.1?(tapStr)
        }
    }
    
    // MARK: ==== Tools ====
    /// 获得符合正则值的range并设置高亮
    private func getRangeList(regex: String) -> [NSRange] {
        var rangeList = [NSRange]()
        let regular   = try? NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
        if let resultList = regular?.matches(in: text, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSMakeRange(0, text.count)) {
            for result in resultList {
                rangeList.append(result.range)
            }
        }
        return rangeList
    }
    
    /// 设置高亮文字
    private func setHeightLight() {
        for rangeTuple in rangeList {
            self.mAttrStr.addAttributes([NSAttributedString.Key.foregroundColor : heightLightColor], range: rangeTuple.0)
            self.height = sizeForText(mAttrStr: mAttrStr, width: width).height
        }
    }
}

