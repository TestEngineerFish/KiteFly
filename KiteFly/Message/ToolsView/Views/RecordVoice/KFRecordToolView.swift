//
//  BPRecordToolView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/22.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit
import STYKit

protocol KFRecordToolViewDelegate: NSObjectProtocol {
    /// 发送语音消息
    func sendAudioMessage(data: Data, local: String, duration: TimeInterval)
    /// 取消发送
    func cancelAudioMessage()
}

/// 录入语音页面
class KFRecordToolView: TYTopWindowView_ty, TYRecordAudioManagerDelegate_ty {

    private let recordViewHeight = AdaptSize_ty(110) + kSafeBottomMargin_ty
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
    weak var delegate: KFRecordToolViewDelegate?

    /// 音浪气泡容器
    private var bubbleImageview: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.size_ty = CGSize(width: AdaptSize_ty(195), height: AdaptSize_ty(83))
        imageView.image           = UIImage(named: "chat_record_audio_normal")
        imageView.contentMode     = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    /// 音浪气泡动画
    private var audioAnimationLayer = KFRecordVoiceAnimationLayer(number: 26, height: AdaptSize_ty(25), isCancel: false)
    /// 取消时展示的气泡
    private var cancelVoiceAnimationLayer = KFRecordVoiceAnimationLayer(number: 10, height: AdaptSize_ty(25), isCancel: true)

    private var timeLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.hex_ty(0x598D3F)
        label.font          = UIFont.regular_ty(AdaptSize_ty(13))
        label.textAlignment = .center
        return label
    }()

    private var tipsLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = "松开发送 上移取消"
        label.font          = UIFont.regular_ty(AdaptSize_ty(12))
        label.textAlignment = .center
        return label
    }()

    private var comitButton: TYButton_ty = {
        let button = TYButton_ty()
//        button.setTitle(IconFont.select.rawValue, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(15))
        button.backgroundColor  = UIColor.gray1
        return button
    }()
    private let recordAreaViewSize = CGSize(width: kScreenWidth_ty, height: AdaptSize_ty(140) + kSafeBottomMargin_ty)
    private lazy var recordAreaViewNormalColor = UIColor.gradientColor_ty(with_ty: recordAreaViewSize, colors_ty: [UIColor.hex_ty(0x9C9C9C).cgColor, UIColor.hex_ty(0xD5D5D5).cgColor], direction_ty: .vertical_ty)
    /// 按下区域
    private lazy var recordAreaView: TYView_ty = {
        let view = TYView_ty()
        view.size_ty = recordAreaViewSize
        view.backgroundColor = recordAreaViewNormalColor
        let path = UIBezierPath(arcCenter: CGPoint(x: view.width_ty/2, y: kScreenWidth_ty), radius: kScreenWidth_ty, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
        path.close()
        let shapelayer = CAShapeLayer()
        shapelayer.path            = path.cgPath
        shapelayer.backgroundColor = UIColor.red.cgColor
        shapelayer.fillColor       = UIColor.green0.cgColor
        shapelayer.borderColor     = UIColor.hex_ty(0xD5D5D5).cgColor
        shapelayer.fillRule        = .nonZero
        shapelayer.borderWidth     = AdaptSize_ty(2)
        view.layer.mask            = shapelayer
        return view
    }()
    private var recordImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.image = UIImage(named: "chat_record_icon_black")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.bindData_ty()
        self.updateUI_ty()
    }

    deinit {
        TYRecordAudioManager_ty.share_ty.delegate_ty = nil
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(recordAreaView)
        self.addSubview(tipsLabel)
        self.addSubview(bubbleImageview)
        recordAreaView.addSubview(recordImageView)
        bubbleImageview.addSubview(timeLabel)
        bubbleImageview.layer.addSublayer(audioAnimationLayer)
        bubbleImageview.layer.addSublayer(cancelVoiceAnimationLayer)
        let animationX = (bubbleImageview.width_ty - audioAnimationLayer.width_ty)/2
        let animationY = (bubbleImageview.height_ty - audioAnimationLayer.height_ty)/2 - AdaptSize_ty(5)
        self.audioAnimationLayer.frame = CGRect(origin: CGPoint(x: animationX, y: animationY), size: audioAnimationLayer.size_ty)
        let cancalAnimationX = (bubbleImageview.width_ty - cancelVoiceAnimationLayer.width_ty)/2
        let cancalAnimationY = (bubbleImageview.height_ty - cancelVoiceAnimationLayer.height_ty)/2 - AdaptSize_ty(5)
        self.cancelVoiceAnimationLayer.frame = CGRect(origin: CGPoint(x: cancalAnimationX, y: cancalAnimationY), size: cancelVoiceAnimationLayer.size_ty)

        recordAreaView.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.size.equalTo(recordAreaView.size_ty)
        }
        recordImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(40), height: AdaptSize_ty(40)))
            make.top.equalToSuperview().offset(AdaptSize_ty(40))
            make.centerX.equalToSuperview()
        }
        tipsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(recordAreaView.snp.top).offset(AdaptSize_ty(-15))
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(tipsLabel.font.lineHeight)
        }
        timeLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(timeLabel.font.lineHeight)
            make.centerY.equalToSuperview().offset(AdaptSize_ty(-5))
        }
        bubbleImageview.snp.makeConstraints { make in
            make.size.equalTo(bubbleImageview.size_ty)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tipsLabel.snp.top).offset(AdaptSize_ty(-190))
        }
    }

    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.cancelVoiceAnimationLayer.isHidden = true
        self.audioAnimationLayer.isHidden       = false
        self.backgroundView_ty.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hide_ty))
        self.addGestureRecognizer(tapGes)
    }

    override func updateUI_ty() {
        super.updateUI_ty()
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
        self.recordAreaView.backgroundColor     = UIColor.hex_ty(0x393939)
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
                self.hide_ty()
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
    internal override func show_ty(view_ty: UIView = kWindow_ty) {
        super.show_ty(view_ty: view_ty)
        TYRecordAudioManager_ty.share_ty.stopRecording_ty()
        TYRecordAudioManager_ty.share_ty.shake_ty()
        self.bubbleImageview.layer.addJellyAnimation_ty()
        TYRecordAudioManager_ty.share_ty.delegate_ty = self
        TYRecordAudioManager_ty.share_ty.startRecording_ty()
    }
    
    @objc
    internal override func hide_ty() {
        self.timer?.invalidate()
        self.timer = nil
        TYRecordAudioManager_ty.share_ty.stopRecording_ty()
        super.hide_ty()
    }

    @objc
    func panAction(sender: UIGestureRecognizer) {
        if let _sender = sender as? UILongPressGestureRecognizer, _sender.state == .began {
            TYAuthorizationManager_ty.share_ty.authorizeMicrophoneWith_ty {  [weak self] result in
                self?.show_ty()
            }
        }
        switch sender.state {
        case .cancelled, .ended:
            self.hide_ty()
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
    func refreshAction_ty(duration_ty: TimeInterval) {
        if duration_ty >= TimeInterval(self.maxSecond - self.countDownSecond) {
            // 显示倒计时
            self.showCountDownWarning()
        }
    }
    /// 录制结束
    func recordFinished_ty(data_ty: Data, local_ty path_ty: String, duration_ty: TimeInterval) {
        if duration_ty < TimeInterval(self.minSecond) {
            kWindow_ty.toast_ty("说话时间太短")
            self.delegate?.cancelAudioMessage()
        } else {
            if isCancel {
                self.delegate?.cancelAudioMessage()
            } else {
                let _time = Int(duration_ty) > self.maxSecond ? TimeInterval(self.maxSecond) : duration_ty
                self.delegate?.sendAudioMessage(data: data_ty, local: path_ty, duration: _time)
            }
        }
    }
    /// 声音回调，每0.1s刷新一次
    func updateVoice_ty(value_ty: Float) {
        let vocality = Int(ceilf(value_ty))
        self.audioAnimationLayer.update(vocality: vocality)
        self.cancelVoiceAnimationLayer.update(vocality: vocality)
    }

}
