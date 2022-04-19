//
//  BPRecordVoiceAnimationLayer.swift
//  MessageCenter
//
//  Created by apple on 2021/11/23.
//  Copyright © 2021 KLC. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit
import STYKit


class KFRecordVoiceAnimationLayer: CALayer {
    
    private var number: Int
    private var isCancel: Bool
    private var itemList: [KFRecordAnimationItemLayer] = []
    private let space: CGFloat = 2
    private let sublayerWidth: CGFloat = 2
    
    init(number: Int, height: CGFloat, isCancel: Bool) {
        self.number   = number
        self.isCancel = isCancel
        super.init()
        self.frame = CGRect(x: 0, y: 0, width: 0, height: height)
        self.createSublayer()
        self.bindProperty_ty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSublayer() {
        for index in 0..<number {
            let _maxScale = self.getMaxScale(index: index)
            let itemLayer = KFRecordAnimationItemLayer()
            itemLayer.bindProperty(maxScale: _maxScale, width: sublayerWidth, height: self.frame.height)
            if isCancel {
                itemLayer.backgroundColor = UIColor.hex_ty(0x963030).cgColor
            } else {
                itemLayer.backgroundColor = UIColor.hex_ty(0x598D3F).cgColor
            }
            let _itemLayerH = self.frame.height * 0.2
            itemLayer.frame = CGRect(x: CGFloat(index) * (sublayerWidth + space), y: (self.frame.height - _itemLayerH)/2, width: sublayerWidth, height: _itemLayerH)
            self.itemList.append(itemLayer)
            self.addSublayer(itemLayer)
        }
        self.width_ty = self.itemList.last?.right_ty ?? 0
    }
    
    private func bindProperty_ty() {
        self.backgroundColor = UIColor.clear.cgColor
    }
    
    func update(vocality: Int) {
        let array = self.getSoundByte(volume: vocality)
        for (index,item) in self.itemList.enumerated() {
            if index < array.count {
                let scale = array[index]
                item.updateHeight(scale: scale)
            } else {
                print(vocality)
                item.updateHeight(scale: 0.5)
            }
        }
    }
    
    /// 更新音浪的颜色
    func updateItemColor(color: CGColor) {
        self.itemList.forEach { item in
            item.backgroundColor = color
        }
    }
    
    // MARK: ==== Tools ====
    private func getSoundByte(volume: Int) -> [CGFloat] {
        switch volume {
            case 0:
                return []
            case 1:
                return [0.10, 0.05, 0.05, 0.07, 0.08,
                        0.02, 0.03, 0.04, 0.05, 0.08,
                        0.1, 0.09, 0.11, 0.12, 0.11,
                        0.08, 0.07, 0.08, 0.11, 0.12,
                        0.10, 0.12, 0.13, 0.27, 0.30,
                        0.2]
            case 2:
                return [0.2, 0.125, 0.15, 0.13, 0.135,
                        0.125, 0.13, 0.135, 0.13, 0.25,
                        0.15, 0.13, 0.25, 0.135, 0.25,
                        0.2, 0.15, 0.3, 0.125, 0.125, 0.15,
                        0.2, 0.1, 0.25, 0.1, 0.2]
            case 3:
                return [0.2, 0.26, 0.2, 0.25, 0.2,
                        0.25, 0.25, 0.21, 0.22, 0.27,
                        0.28, 0.1, 0.35, 0.3, 0.28,
                        0.2, 0.15, 0.2, 0.25, 0.3, 0.25,
                        0.26, 0.25, 0.27, 0.2, 0.22]
            case 4:
                return [0.2, 0.24, 0.3, 0.24, 0.25,
                        0.3, 0.35, 0.4, 0.35, 0.33,
                        0.31, 0.28, 0.2, 0.2, 0.35,
                        0.3, 0.25, 0.3, 0.3, 0.35, 0.3,
                        0.35, 0.4, 0.37, 0.2, 0.3]
            case 5:
                return [0.2, 0.1, 0.35, 0.5, 0.4,
                        0.35, 0.25, 0.3, 0.4, 0.5,
                        0.3, 0.4, 0.3, 0.45, 0.55,
                        0.4, 0.55, 0.4, 0.3, 0.2, 0.3,
                        0.5, 0.45, 0.2, 0.2, 0.5]
            case 6:
                return [0.5, 0.5, 0.45, 0.3, 0.6,
                        0.5, 0.35, 0.3, 0.35, 0.45,
                        0.7, 0.6, 0.7, 0.55, 0.45,
                        0.2, 0.25, 0.3, 0.4, 0.3, 0.5,
                        0.6, 0.65, 0.6, 0.5, 0.3]
            case 7:
                return [0.3, 0.35, 0.5, 0.55, 0.65,
                        0.75, 0.4, 0.5, 0.6, 0.55,
                        0.5, 0.4, 0.35, 0.35, 0.7,
                        0.6, 0.55, 0.7, 0.6, 0.5, 0.4,
                        0.4, 0.55, 0.7, 0.6, 0.4]
            case 8:
                return [0.3, 0.6, 0.45, 0.4, 0.5,
                        0.35, 0.75, 0.85, 0.75, 0.65,
                        0.55, 0.35, 0.25, 0.35, 0.45,
                        0.55, 0.65, 0.8, 0.7, 0.65,
                        0.45, 0.65, 0.90, 0.74, 0.6,
                        0.4]
            case 9:
                return [0.4, 0.2, 0.45, 0.6, 0.8,
                        0.95, 0.75, 0.55, 0.45, 0.5,
                        0.65, 0.25, 0.45, 0.55, 0.75,
                        0.5, 0.35, 0.55, 0.75, 0.95, 0.75,
                        0.55, 0.30, 0.65, 0.45, 0.3]
            case 10:
                return [0.8, 0.6, 0.4, 0.3, 0.9,
                        0.7, 0.55, 0.35, 0.4, 0.35,
                        0.55, 0.75, 0.95, 0.7, 0.55,
                        0.5, 0.55, 0.7, 0.5, 0.7, 0.6,
                        0.75, 0.95, 0.77, 0.6, 0.4]
            default:
                return []
        }
    }
    
    private func getMaxScale(index: Int) -> CGFloat {
        switch index {
            case 0:
                return 0.5
            case 1:
                return 0.7
            case 2:
                return 0.55
            case 3:
                return 0.45
            case 4:
                return 0.6
            case 5:
                return 0.7
            case 6:
                return 0.65
            case 7:
                return 0.9
            case 8:
                return 0.75
            case 9:
                return 0.9
            case 10:
                return 0.95
            case 11:
                return 0.75
            case 12:
                return 0.65
            case 13:
                return 0.55
            case 14:
                return 0.45
            case 15:
                return 0.5
            case 16:
                return 0.6
            case 17:
                return 0.7
            case 18:
                return 0.75
            case 19:
                return 0.9
            case 20:
                return 0.8
            case 21:
                return 0.3
            case 22:
                return 0.4
            case 23:
                return 0.5
            case 24:
                return 0.6
            case 25:
                return 0.7
            case 26:
                return 0.5
            default:
                return 0.4
        }
    }
}
