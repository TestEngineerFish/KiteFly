//
//  BPProgressView.swift
//  Tenant
//
//  Created by samsha on 2021/1/14.
//

import UIKit

public enum BPProgressType: Int {
    /// 直线
    case line
    /// 圆形
    case round
}

public class BPProgressView: BPView {
    private var type: BPProgressType
    private var lineWidth: CGFloat
    
    private var progressLayer = CAShapeLayer()
    
    /// lineWidth: 仅适用于非直线进度条
    public init(type: BPProgressType, size: CGSize, lineWidth: CGFloat = AdaptSize(10)) {
        self.type      = type
        self.lineWidth = lineWidth
        super.init(frame: CGRect(origin: .zero, size: size))
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.progressLayer.frame = CGRect(origin: .zero, size: size)
        switch type {
            case .line:
                self.drawLineShape()
            case .round:
                self.drawRoundShape()
        }
    }
    
    public override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .clear
    }
    
    // MARK: ==== Event ====
    private func drawLineShape() {
        let bottomLayer             = CAShapeLayer()
        bottomLayer.frame           = bounds
        bottomLayer.backgroundColor = UIColor.gray1.cgColor
        bottomLayer.cornerRadius    = height/2
        self.layer.addSublayer(bottomLayer)
        
        progressLayer.frame           = CGRect(x: 0, y: 0, width: 0, height: height)
        progressLayer.backgroundColor = UIColor.blue.cgColor
        progressLayer.cornerRadius    = height/2
        
        self.layer.addSublayer(progressLayer)
    }
    
    private func drawRoundShape() {
        let center     = CGPoint(x: width/2, y: height/2)
        let radius     = (width - lineWidth*2)/2
        let startAngle = -CGFloat.pi/2
        let endAngle   = CGFloat.pi*3/2
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let bottomLayer         = CAShapeLayer()
        bottomLayer.path        = path.cgPath
        bottomLayer.frame       = bounds
        bottomLayer.fillColor   = UIColor.clear.cgColor
        bottomLayer.strokeColor = UIColor.clear.cgColor
        bottomLayer.lineWidth   = lineWidth
        self.layer.addSublayer(bottomLayer)
        
        progressLayer.path        = path.cgPath
        progressLayer.lineWidth   = lineWidth
        progressLayer.lineCap     = .round
        progressLayer.fillColor   = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.strokeEnd   = 0
        self.layer.addSublayer(progressLayer)
    }
    
    public func setProgress(progress: CGFloat, duration: TimeInterval = 0.25, complete block: DefaultBlock? = nil) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            switch self.type {
                case .line:
                    self.progressLayer.width = self.width * progress
                case .round:
                    self.progressLayer.strokeEnd = progress
            }
        } completion: { finished in
            if finished {
                block?()
            }
        }
    }
}
