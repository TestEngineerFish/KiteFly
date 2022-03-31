//
//  BPBrowserVideoCell.swift
//  Tenant
//
//  Created by samsha on 2021/8/18.
//

import UIKit
import AVFoundation

protocol BPBrowserVideoCellDelegate: NSObjectProtocol {
    func videoViewLongPressAction(model: BPMediaVideoModel?)
    func videoViewClosedAction(view: UIView)
    func scrolling(reduce scale: Float)
    func closeAction(view: UIView)
}

class BPBrowserVideoCell:
    BPCollectionViewCell,
    BPVideoManagerDelegate,
    UIGestureRecognizerDelegate {
    
    weak var delegate: BPBrowserVideoCellDelegate?
    private let playManager = BPVideoManager()
    private var model: BPMediaVideoModel?
    // TODO: ---- 手势相关 ----
    private var originPoint = CGPoint.zero
    /// 手指离开后，超过该值则关闭视图
    private let maxOffsetY: CGFloat     = 100
    /// 页面是否在滑动中
    private var isScrolling     = false
    /// 最大滑动缩放范围
    private let maxScaleY: CGFloat      = AdaptSize(1000)
    /// 拖动最小缩放比例
    private let drawMinScale: CGFloat   = 0.5
    
    private var customContentView = BPView()
    
    private var playButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.arrowDownSolid.rawValue, for: .normal)
        button.setTitle(IconFont.arrowUpSolid.rawValue, for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(16))
        button.isHidden = true
        return button
    }()
    
    private var leftTimeLabel: BPLabel = {
        let label = BPLabel()
        label.text          = "00:00"
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .left
        return label
    }()
    
    private var rightTimeLabel: BPLabel = {
        let label = BPLabel()
        label.text          = "00:00"
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .left
        return label
    }()
    
    private var progressView = BPProgressView(type: .line, size: CGSize(width: AdaptSize(250), height: AdaptSize(2)))
    
    private var closedButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.close.rawValue, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font    = UIFont.iconFont(size: AdaptSize(10))
        button.backgroundColor     = UIColor.gray0.withAlphaComponent(0.4)
        button.layer.cornerRadius  = AdaptSize(15)
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.updateUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func createSubviews() {
        self.contentView.addSubview(customContentView)
        self.customContentView.addSubview(playButton)
        self.customContentView.addSubview(leftTimeLabel)
        self.customContentView.addSubview(progressView)
        self.customContentView.addSubview(rightTimeLabel)
        self.customContentView.addSubview(closedButton)
        
        customContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        closedButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.bottom.equalToSuperview().offset(AdaptSize(-15) - kSafeBottomMargin)
            make.size.equalTo(CGSize(width: AdaptSize(30), height: AdaptSize(30)))
        }
        playButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(40)))
            make.left.equalToSuperview()
            make.bottom.equalTo(closedButton.snp.top).offset(AdaptSize(-20))
        }
        leftTimeLabel.sizeToFit()
        leftTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(playButton.snp.right)
            make.centerY.equalTo(playButton)
            make.width.equalTo(leftTimeLabel.width)
            make.height.equalTo(leftTimeLabel.font.lineHeight)
        }
        progressView.snp.makeConstraints { make in
            make.left.equalTo(leftTimeLabel.snp.right).offset(AdaptSize(5))
            make.centerY.equalTo(playButton)
            make.size.equalTo(progressView.size)
        }
        rightTimeLabel.sizeToFit()
        rightTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(progressView.snp.right).offset(AdaptSize(5))
            make.centerY.equalTo(playButton)
            make.height.equalTo(rightTimeLabel.font.lineHeight)
            make.width.equalTo(rightTimeLabel.width)
        }
    }
    
    internal override func bindProperty() {
        self.closedButton.addTarget(self, action: #selector(closedAction), for: .touchUpInside)
        self.playButton.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        self.playManager.delegate = self
        self.configGesture()
    }
    
    override func updateUI() {
        super.updateUI()
        self.backgroundColor                   = UIColor.clear
        self.contentView.backgroundColor       = UIColor.clear
        self.customContentView.backgroundColor = UIColor.clear
    }
    
    /// 配置手势
    private func configGesture() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGesAction))
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(sender:)))
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(panGesAction(sender:)))
        panGes.maximumNumberOfTouches = 1
        panGes.delegate = self
        self.addGestureRecognizer(tapGes)
        self.addGestureRecognizer(longPressGes)
        self.customContentView.addGestureRecognizer(panGes)
    }
    
    // MARK: ==== Event ====
    func setData(model: BPMediaVideoModel) {
        self.model = model
        self.playManager.setData(model: model, contentLayer: self.customContentView.layer)
    }
    
    @objc private func playAction(sender: BPButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.playAction()
        } else {
            self.pauseAction()
        }
    }
    
    @objc private func closedAction() {
        self.delegate?.videoViewClosedAction(view: self.contentView)
    }
    
    @objc private func playAction() {
        self.playManager.play()
    }
    
    @objc private func pauseAction() {
        self.playManager.pause()
    }
    
    @objc private func tapGesAction() {
        self.playButton.isHidden     = !self.playButton.isHidden
        self.leftTimeLabel.isHidden  = !self.leftTimeLabel.isHidden
        self.progressView.isHidden   = !self.progressView.isHidden
        self.rightTimeLabel.isHidden = !self.rightTimeLabel.isHidden
        self.closedButton.isHidden   = !self.closedButton.isHidden
    }
    
    @objc private func longPressAction(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.delegate?.videoViewLongPressAction(model: self.model)
        }
    }
    
    @objc private func panGesAction(sender: UIPanGestureRecognizer) {
        
        let point = sender.translation(in: self.customContentView)
        switch sender.state {
        case .began:
            self.originPoint = point
        case .changed:
            guard point.y > 10, !isScrolling else {
                return
            }
            let scale: CGFloat = {
                if point.y > self.maxScaleY {
                    return self.drawMinScale
                } else {
                    let _scale = (self.maxScaleY - point.y) / self.maxScaleY
                    return _scale > self.drawMinScale ? _scale : self.drawMinScale
                }
            }()
            self.delegate?.scrolling(reduce: Float(scale))
            // a:控制x轴缩放；d：控制y轴缩放；
            self.customContentView.transform = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: point.x, ty: point.y)
        case .ended:
            if point.y - originPoint.y > self.maxOffsetY {
                self.delegate?.closeAction(view: self.customContentView)
            } else {
                UIView.animate(withDuration: 0.15) { [weak self] in
                    self?.customContentView.transform = .identity
                }
            }
        default:
            return
        }
    }
    
    // MARK: ==== BPVideoManagerDelegate ====
    /// 开始播放
    func playBlock() {
        self.playButton.isSelected = true
    }
    /// 暂停播放
    func pauseBlock() {
        self.playButton.isSelected = false
    }
    /// 播放进度
    func progressBlock(progress: Double, currentSecond: Double) {
        self.progressView.setProgress(progress: CGFloat(progress))
        self.leftTimeLabel.text = currentSecond.minuteSecondStr()
    }
    func updateStatus(status: AVPlayerItem.Status) {
        if status == .readyToPlay {
            self.playButton.isHidden = false
        }
    }
    
    // MARK: ==== UIGestureRecognizerDelegate ====
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

