//
//  BPRecordAnimationItemLayer.swift
//  MessageCenter
//
//  Created by apple on 2021/11/23.
//  Copyright © 2021 KLC. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class BPRecordAnimationItemLayer: CALayer {
    
    var maxHeightScale: CGFloat = 1.0
    var minHeightScale: CGFloat = 0.3
    var maxHeight: CGFloat = .zero
    
    func bindProperty(maxScale: CGFloat, width: CGFloat, height: CGFloat) {
        self.maxHeight      = height
        self.maxHeightScale = maxScale
        self.cornerRadius   = width/2
        self.masksToBounds  = true
        self.backgroundColor = UIColor.white.cgColor
    }
    
    // MARK: ==== Event ====
    func updateHeight(scale: CGFloat) {
        let _heigth = self.maxHeight * scale
        let _y = (self.maxHeight - _heigth)/2
        self.frame = CGRect(x: self.frame.minX, y: _y, width: self.frame.width, height: _heigth)
    }
}

