//
//  UIColor+Extension.swift
//  MessageCenter
//
//  Created by apple on 2021/10/28.
//  Copyright © 2021 KLC. All rights reserved.
//

import UIKit

public extension UIColor {
    class func make(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        }else{
            return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        }
    }

    /// 十六进制颜色值
    /// - parameter hex: 十六进制值,例如: 0x000fff
    /// - parameter alpha: 透明度
    class func hex(_ hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        if hex > 0xFFF {
            let divisor = CGFloat(255)
            let red     = CGFloat((hex & 0xFF0000) >> 16) / divisor
            let green   = CGFloat((hex & 0xFF00  ) >> 8)  / divisor
            let blue    = CGFloat( hex & 0xFF    )        / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            let divisor = CGFloat(15)
            let red     = CGFloat((hex & 0xF00) >> 8) / divisor
            let green   = CGFloat((hex & 0x0F0) >> 4) / divisor
            let blue    = CGFloat( hex & 0x00F      ) / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
    
    /// 根据方向,设置渐变色
    ///
    /// - Parameters:
    ///   - size: 渐变区域大小
    ///   - colors: 渐变色数组
    ///   - direction: 渐变方向
    /// - Returns: 渐变后的颜色,如果设置失败,则返回nil
    /// - note: 设置前,一定要确定当前View的高宽!!!否则无法准确的绘制
    class func gradientColor(with size: CGSize, colors: [CGColor], direction: GradientDirectionType) -> UIColor? {
        switch direction {
        case .horizontal:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        case .vertical:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
        case .leftTop:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        case .leftBottom:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        }
    }

    /// 设置渐变色
    /// - parameter size: 渐变文字区域的大小.也就是用于绘制的区域
    /// - parameter colors: 渐变的颜色数组,从左到右顺序渐变,区域均匀分布
    /// - parameter startPoint: 渐变开始坐标
    /// - parameter endPoint: 渐变结束坐标
    /// - returns: 返回一个渐变的color,如果绘制失败,则返回nil;
    class func gradientColor(with size: CGSize, colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) -> UIColor? {
        autoreleasepool {
            // 设置画布,开始准备绘制
            UIGraphicsBeginImageContextWithOptions(size, false, kScreenScale)
            // 获取当前画布上下文,用于操作画布对象
            guard let context     = UIGraphicsGetCurrentContext() else { return nil }
            // 创建RGB空间
            let colorSpaceRef     = CGColorSpaceCreateDeviceRGB()
            // 在RGB空间中绘制渐变色,可设置渐变色占比,默认均分
            guard let gradientRef = CGGradient(colorsSpace: colorSpaceRef, colors: colors as CFArray, locations: nil) else { return nil }
            // 设置渐变起始坐标
            let startPoint        = CGPoint(x: size.width * startPoint.x, y: size.height * startPoint.y)
            // 设置渐变结束坐标
            let endPoint          = CGPoint(x: size.width * endPoint.x, y: size.height * endPoint.y)
            // 开始绘制图片
            context.drawLinearGradient(gradientRef, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: CGGradientDrawingOptions.drawsBeforeStartLocation.rawValue | CGGradientDrawingOptions.drawsAfterEndLocation.rawValue))
            
            
            // 获取渐变图片
            if let gradientImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return UIColor(patternImage: gradientImage)
            }
            UIGraphicsEndImageContext()
            return nil
        }
        
       
    }
    
}
//MARK: **************** 颜色值 **********************
public extension UIColor {

    //MARK: 颜色快捷设置相关函数
    static func ColorWithRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.make(red: red, green: green, blue: blue, alpha: alpha)
    }

    static func ColorWithHexRGBA(_ hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.hex(hex, alpha: alpha)
    }

    /// 获得随机颜色
    /// - Returns: 随机颜色
    static func randomColor(alpheRandom: Bool = false) -> UIColor {
        let red   = CGFloat.random(in: 0...255)
        let green = CGFloat.random(in: 0...255)
        let blue  = CGFloat.random(in: 0...255)
        var alphe = CGFloat(1)
        if alpheRandom {
            alphe = CGFloat.random(in: 0...1)
        }
        return ColorWithRGBA(red: red, green: green, blue: blue, alpha: alphe)
    }
    
    // TODO: ====== Green ====
    
    /// 文字 (red: 34, green: 34, blue: 34)
    static let black0 = ColorWithRGBA(red: 34, green: 34, blue: 34)
    /// 空页面提示 (red: 102, green: 102, blue: 102)
    static let black1 = ColorWithRGBA(red: 102, green: 102, blue: 102)
    /// 单选文字 (red: 51, green: 51, blue: 51)
    static let black2 = ColorWithRGBA(red: 51, green: 51, blue: 51)
    
    /// 分割线 (red: 249, green: 249, blue: 249)
    static let gray0 = ColorWithRGBA(red: 249, green: 249, blue: 249)
    /// 文字 (red: 166, green: 166, blue: 166)
    static let gray1 = ColorWithRGBA(red: 166, green: 166, blue: 166)
    /// 向右箭头 (red: 204, green: 204, blue: 204)
    static let gray2 = ColorWithRGBA(red: 204, green: 204, blue: 204)
    /// 取消按钮 (red: 242, green: 242, blue: 242)
    static let gray3 = ColorWithRGBA(red: 242, green: 242, blue: 242)
    /// 分割线 (red: 238, green: 238, blue: 238)
    static let gray4 = ColorWithRGBA(red: 238, green: 238, blue: 238)
    /// ActionSheetTitle (red: 92, green: 98, blue: 112)
    static let gray5 = ColorWithRGBA(red: 92, green: 98, blue: 112)
    /// 设置按钮文案 (red: 87, green: 107, blue: 149)
    static let gray6 = ColorWithRGBA(red: 87, green: 107, blue: 149)
    /// 提示文案 (red: 153, green: 153, blue: 153)
    static let gray7 = ColorWithRGBA(red: 153, green: 153, blue: 153)
    /// 礼物选中背景文案 (red: 250, green: 248, blue: 255)
    static let gray8 = ColorWithRGBA(red: 250, green: 248, blue: 255)
    /// 礼物未选中背景文案 (red: 136, green: 136, blue: 136)
    static let gray9 = ColorWithRGBA(red: 136, green: 136, blue: 136)
    /// PageControl TintColor (red: 127, green: 127, blue: 127)
    static let gray10 = ColorWithRGBA(red: 127, green: 127, blue: 127)
    /// 小灰条背景色 (red: 234, green: 234, blue: 234)
    static let gray11 = ColorWithRGBA(red: 234, green: 234, blue: 234)
    
    /// 小红点 (red: 255, green: 71, blue: 71)
    static let red0 = ColorWithRGBA(red: 255, green: 15, blue: 75)
    /// 单选按钮：删除等 (red: 227, green: 0, blue: 0)
    static let red1 = ColorWithRGBA(red: 227, green: 0, blue: 0)
    /// 亲密度： (red: 255, green: 32, blue: 45)
    static let red2 = ColorWithRGBA(red: 255, green: 32, blue: 45)
    
    /// 亲密度弹框： (red: 254, green: 44, blue: 112)
    static let pink0 = ColorWithRGBA(red: 254, green: 44, blue: 112)
    /// 亲密度弹框标题背景：(red: 255, green: 239, blue: 247)
    static let pink1 = ColorWithRGBA(red: 255, green: 239, blue: 247)
    
    /// 发送的消息 (red: 227, green: 0, blue: 0)
    static let green0 = ColorWithRGBA(red: 28, green: 221, blue: 126)
    
    /// 展开  (red: 0, green: 137, blue: 255)
    static let blue0 = ColorWithRGBA(red: 0, green: 137, blue: 255)
    
    /// 音视频通话价格描述  (red: 254, green: 90, blue: 63)
    static let orange0 = ColorWithRGBA(red: 254, green: 90, blue: 63)
    
    /// VIP提示文案  (red: 125, green: 99, blue: 47)
    static let yellow0 = ColorWithRGBA(red: 255, green: 99, blue: 47)
    /// 开通贵族价格文案  (red: 254, green: 211, blue: 184)
    static let yellow1 = ColorWithRGBA(red: 254, green: 211, blue: 184)
    /// 去充值按钮  (red: 255, green: 184, blue: 0)
    static let yellow2 = ColorWithRGBA(red: 255, green: 184, blue: 0)
    
    /// VIP开通文字颜色 (red: 52, green: 39, blue: 41)
    static let brown0 = ColorWithRGBA(red: 52, green: 39, blue: 41)
    /// 亲密度规则标题 (red: 148, green: 91, blue: 99)
    static let brown1 = ColorWithRGBA(red: 148, green: 91, blue: 99)
    
    /// 高亮文字颜色 (red: 226, green: 42, blue: 255)
    static let purple0 = ColorWithRGBA(red: 226, green: 42, blue: 255)
    /// 礼物选中边框颜色 (red: 209, green: 187, blue: 250)
    static let purple1 = ColorWithRGBA(red: 209, green: 187, blue: 250)
    /// 同城项目的主体紫色 (red: 209, green: 187, blue: 250)
    static let purple2 = ColorWithRGBA(red: 132, green: 120, blue: 250)

    static let theme = ColorWithRGBA(red: 255, green: 196, blue: 47)
    
    /// 主题渐变
    static let themeGradientList = [UIColor.hex(0xFF68E8).cgColor, UIColor.hex(0xB741FE).cgColor, UIColor.hex(0x669BFF).cgColor]
    /// VIP渐变
    static let vipGradientList   = [UIColor.hex(0xFDE3D4).cgColor, UIColor.hex(0xF3C0A3).cgColor]
    /// 关注渐变
    static let orangeGradientList = [UIColor.hex(0xFF8C6D).cgColor, UIColor.hex(0xFF5425).cgColor]
}
