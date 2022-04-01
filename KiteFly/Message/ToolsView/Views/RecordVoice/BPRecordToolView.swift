//
//  BPRecordToolView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/22.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

protocol BPRecordToolViewDelegate: NSObjectProtocol {
    /// 发送语音消息
    func sendAudioMessage(data: Data, local: String, duration: TimeInterval)
    /// 取消发送
    func cancelAudioMessage()
}

/// 录入语音页面
class BPRecordToolView: BPTopWindowView, BPAudioManagerDelegate {

    private let recordViewHeight = AdaptSize(110) + kSafeBottomMargin
    /// 最大录制时间（秒）
    private let maxSecond = 60
    /// 倒计时提示时间（秒）
    private let countDownSecond = 10
    /// 最小录制时间（秒）
    private let minSecond = 1
    private var timer: Timer?
    private var isCancel        = false
    /// 是否显示倒计时状态
    private var isShowCountDown = false
    weak var delegate: BPRecordToolViewDelegate?

    /// 音浪气泡容器
    private var bubbleImageview: BPImageView = {
        let imageView = BPImageView()
        imageView.size = CGSize(width: AdaptSize(195), height: AdaptSize(83))
        imageView.image           = UIImage(named: "chat_record_audio_normal")
        imageView.contentMode     = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    /// 音浪气泡动画
    private var audioAnimationLayer = BPRecordVoiceAnimationLayer(number: 26, height: AdaptSize(25), isCancel: false)
    /// 取消时展示的气泡
    private var cancelVoiceAnimationLayer = BPRecordVoiceAnimationLayer(number: 10, height: AdaptSize(25), isCancel: true)

    private var timeLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.hex(0x598D3F)
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .center
        return label
    }()

    private var tipsLabel: BPLabel = {
        let label = BPLabel()
        label.text          = "松开发送 上移取消"
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .center
        return label
    }()

    private var comitButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.select.rawValue, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(15))
        button.backgroundColor  = UIColor.gray1
        return button
    }()
    private let recordAreaViewSize = CGSize(width: kScreenWidth, height: AdaptSize(140) + kSafeBottomMargin)
    private lazy var recordAreaViewNormalColor = UIColor.gradientColor(with: recordAreaViewSize, colors: [UIColor.hex(0x9C9C9C).cgColor, UIColor.hex(0xD5D5D5).cgColor], direction: .vertical)
    /// 按下区域
    private lazy var recordAreaView: BPView = {
        let view = BPView()
        view.size = recordAreaViewSize
        view.backgroundColor = recordAreaViewNormalColor
        let path = UIBezierPath(arcCenter: CGPoint(x: view.width/2, y: kScreenWidth), radius: kScreenWidth, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
        path.close()
        let shapelayer = CAShapeLayer()
        shapelayer.path            = path.cgPath
        shapelayer.backgroundColor = UIColor.red.cgColor
        shapelayer.fillColor       = UIColor.green0.cgColor
        shapelayer.borderColor     = UIColor.hex(0xD5D5D5).cgColor
        shapelayer.fillRule        = .nonZero
        shapelayer.borderWidth     = AdaptSize(2)
        view.layer.mask            = shapelayer
        return view
    }()
    private var recordImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.image = UIImage(named: "chat_record_icon_black")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.bindData()
        self.updateUI()
    }

    deinit {
        BPAudioManager.share.delegate = nil
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(recordAreaView)
        self.addSubview(tipsLabel)
        self.addSubview(bubbleImageview)
        recordAreaView.addSubview(recordImageView)
        bubbleImageview.addSubview(timeLabel)
        bubbleImageview.layer.addSublayer(audioAnimationLayer)
        bubbleImageview.layer.addSublayer(cancelVoiceAnimationLayer)
        let animationX = (bubbleImageview.width - audioAnimationLayer.width)/2
        let animationY = (bubbleImageview.height - audioAnimationLayer.height)/2 - AdaptSize(5)
        self.audioAnimationLayer.frame = CGRect(origin: CGPoint(x: animationX, y: animationY), size: audioAnimationLayer.size)
        let cancalAnimationX = (bubbleImageview.width - cancelVoiceAnimationLayer.width)/2
        let cancalAnimationY = (bubbleImageview.height - cancelVoiceAnimationLayer.height)/2 - AdaptSize(5)
        self.cancelVoiceAnimationLayer.frame = CGRect(origin: CGPoint(x: cancalAnimationX, y: cancalAnimationY), size: cancelVoiceAnimationLayer.size)

        recordAreaView.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.size.equalTo(recordAreaView.size)
        }
        recordImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(40)))
            make.top.equalToSuperview().offset(AdaptSize(40))
            make.centerX.equalToSuperview()
        }
        tipsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(recordAreaView.snp.top).offset(AdaptSize(-15))
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(tipsLabel.font.lineHeight)
        }
        timeLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(timeLabel.font.lineHeight)
            make.centerY.equalToSuperview().offset(AdaptSize(-5))
        }
        bubbleImageview.snp.makeConstraints { make in
            make.size.equalTo(bubbleImageview.size)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tipsLabel.snp.top).offset(AdaptSize(-190))
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.cancelVoiceAnimationLayer.isHidden = true
        self.audioAnimationLayer.isHidden       = false
        self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.addGestureRecognizer(tapGes)
    }

    override func updateUI() {
        super.updateUI()
        self.backgroundColor                 = UIColor.clear
        self.tipsLabel.textColor             = UIColor.white
        self.recordImageView.backgroundColor = UIColor.clear
    }

    // MARK: ==== Event ====
    /// 显示可取消警告页面
    private func showCancelWarning() {
        self.isCancel                           = true
        self.timeLabel.isHidden                 = true
        self.audioAnimationLayer.isHidden       = true
        self.cancelVoiceAnimationLayer.isHidden = false
        self.tipsLabel.text                     = "松开手指 取消发送"
        self.bubbleImageview.image              = UIImage(named: "chat_record_audio_cancel")
        self.recordAreaView.backgroundColor     = UIColor.hex(0x393939)
        self.recordImageView.image              = UIImage(named: "chat_record_icon_gray")
    }

    /// 显示正常录制页面
    private func showNormal() {
        self.isCancel                           = false
        if isShowCountDown {
            self.audioAnimationLayer.isHidden   = true
            self.timeLabel.isHidden             = false
        } else {
            self.audioAnimationLayer.isHidden   = false
            self.timeLabel.isHidden             = true
        }
        self.cancelVoiceAnimationLayer.isHidden = true
        self.bubbleImageview.image              = UIImage(named: "chat_record_audio_normal")
        self.tipsLabel.text                     = "松开发送 上移取消"
        self.recordAreaView.backgroundColor     = self.recordAreaViewNormalColor
        self.recordImageView.image              = UIImage(named: "chat_record_icon_black")
    }

    /// 显示倒计时页面
    private func showCountDownWarning() {
        guard !self.isShowCountDown else { return }
        self.isShowCountDown = true
        self.audioAnimationLayer.isHidden = true
        
        var time   = countDownSecond
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if time <= 0 {
                self.hide()
            }
            if self.isCancel {
                self.timeLabel.isHidden = true
            } else {
                self.timeLabel.isHidden = false
            }
            self.timeLabel.text = "\(time)\" 后将停止录音"
            time -= 1
        }
        self.timer?.fire()

    }
    
    internal override func show(view: UIView = kWindow) {
        super.show(view: view)
        BPPlayerManager.share.stop()
        shake()
        self.bubbleImageview.layer.addJellyAnimation()
        BPAudioManager.share.delegate = self
        BPAudioManager.share.startRecording()
    }
    
    @objc
    internal override func hide() {
        self.timer?.invalidate()
        self.timer = nil
        BPAudioManager.share.stopRecording()
        super.hide()
    }

    @objc
    func panAction(sender: UIGestureRecognizer) {
        if let _sender = sender as? UILongPressGestureRecognizer, _sender.state == .began {
            BPAuthorizationManager.share.authorizeMicrophoneWith { [weak self] result in
                self?.show()
            }
            
        }
        switch sender.state {
        case .cancelled, .ended:
            self.hide()
        case .changed:
            let point = sender.location(in: self.recordAreaView)
            if point.y < 0 {
                self.showCancelWarning()
            } else {
                self.showNormal()
            }
        default:
            break
        }
    }

    // MARK: ==== BPAudioManagerDelegate ====
    /// 每0.1s刷新一次
    func refreshAction(duration: TimeInterval) {
        if duration >= TimeInterval(self.maxSecond - self.countDownSecond) {
            // 显示倒计时
            self.showCountDownWarning()
        }
    }
    /// 录制结束
    func recordFinished(data: Data, local path: String, duration: TimeInterval) {
        if duration < TimeInterval(self.minSecond) {
            kWindow.toast("说话时间太短")
            self.delegate?.cancelAudioMessage()
        } else {
            if isCancel {
                self.delegate?.cancelAudioMessage()
            } else {
                let _time = Int(duration) > self.maxSecond ? TimeInterval(self.maxSecond) : duration
                self.delegate?.sendAudioMessage(data: data, local: path, duration: _time)
            }
        }
    }
    /// 声音回调，每0.1s刷新一次
    func updateVoice(value: Float) {
        let vocality = Int(ceilf(value))
        self.audioAnimationLayer.update(vocality: vocality)
        self.cancelVoiceAnimationLayer.update(vocality: vocality)
    }

}
