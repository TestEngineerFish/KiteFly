//
//  BPChatRoomMessageAudioCell.swift
//  MessageCenter
//
//  Created by apple on 2021/12/17.
//  Copyright © 2021 KLC. All rights reserved.
//

import Foundation
import UIKit
import RongIMLib

class BPChatRoomMessageAudioCell: BPChatRoomMessageCell {
    
    /// 语音最大长度
    private let maxW = kScreenWidth / 2
    private let minW = AdaptSize(47)
    /// 最大语音时长
    private let maxAudioLength: CGFloat = 60

    private var animationImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode          = .scaleAspectFill
        imageView.animationDuration    = 1.5
        imageView.animationRepeatCount = 0
        return imageView
    }()
    
    private var durationLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.font          = UIFont.semiboldFont(ofSize: AdaptSize(15))
        label.numberOfLines = 0
        return label
    }()
    /// 发送的语音动画
    private let sendAnimationImages: [UIImage] = {
        var animationImages = [UIImage]()
        if let firstImage = UIImage(named: "chat_audio_play_send_0") {
            animationImages.append(firstImage)
        }
        if let secondImage = UIImage(named: "chat_audio_play_send_1") {
            animationImages.append(secondImage)
        }
        if let thirdlyImage = UIImage(named: "chat_audio_play_send_2") {
            animationImages.append(thirdlyImage)
        }
        return animationImages
    }()
    
    /// 接收的语音动画
    private let receiveAnimationImages: [UIImage] = {
        var animationImages = [UIImage]()
        if let firstImage = UIImage(named: "chat_audio_play_receive_0") {
            animationImages.append(firstImage)
        }
        if let secondImage = UIImage(named: "chat_audio_play_receive_1") {
            animationImages.append(secondImage)
        }
        if let thirdlyImage = UIImage(named: "chat_audio_play_receive_2") {
            animationImages.append(thirdlyImage)
        }
        return animationImages
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.bubbleView.addSubview(animationImageView)
        self.bubbleView.addSubview(durationLabel)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.bubbleView.backgroundImageView.isHidden = false
    }
    
    // MARK: ==== Event ====
    override func registerNotification() {
        super.registerNotification()
    }
    
    override func setBubbleView() {
        super.setBubbleView()
        guard let messageModel = self.messageModel else { return }
        if messageModel.messageDirection == .MessageDirection_SEND {
            self.bubbleView.setRightGreenBackground()
            self.durationLabel.textAlignment = .right
            self.durationLabel.textColor     = UIColor.white
            self.animationImageView.image    = UIImage(named: "chat_audio_play_send_2")
            self.animationImageView.animationImages = sendAnimationImages
            
            self.durationLabel.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(AdaptSize(10))
                make.right.equalTo(animationImageView.snp.left).offset(AdaptSize(-7))
                make.height.equalTo(AdaptSize(40))
                make.width.equalTo(minW)
            }
            self.animationImageView.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
                make.right.equalToSuperview().offset(AdaptSize(-10))
            }
        } else {
            self.bubbleView.setLeftWhiteBackground()
            self.durationLabel.textColor     = UIColor.black2
            self.durationLabel.textAlignment = .left
            self.animationImageView.image    = UIImage(named: "chat_audio_play_receive_2")
            self.animationImageView.animationImages = receiveAnimationImages
            self.animationImageView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(AdaptSize(10))
                make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
                make.centerY.equalToSuperview()
            }
            self.durationLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(animationImageView.snp.right).offset(AdaptSize(7))
                make.bottom.top.equalToSuperview()
                make.right.equalToSuperview().offset(AdaptSize(-10))
                make.height.equalTo(AdaptSize(40))
                make.width.equalTo(minW)
            }
        }
        
        guard let audioMessage = messageModel.content as? RCHQVoiceMessage else {
            return
        }
        self.durationLabel.text = "\(audioMessage.duration)\""
        // -- 计算bubble宽度
        let availableWidth = self.maxW - self.minW
        var labelWidth     = availableWidth * CGFloat(audioMessage.duration)/maxAudioLength
        labelWidth         = labelWidth < durationLabel.font.lineHeight ? durationLabel.font.lineHeight : labelWidth
        self.durationLabel.snp.updateConstraints { make in
            make.width.equalTo(labelWidth)
        }
        if audioMessage.isPlaying {
            self.startPlayAnimation()
        } else {
            self.stopPlayAnimation()
        }
    }
    
    override func clickBubble() {
        super.clickBubble()
        guard let audioContent = self.messageModel?.content as? RCHQVoiceMessage else {
            return
        }
        if audioContent.isPlaying {
            BPPlayerManager.share.stop()
            self.stopPlayAnimation()
            audioContent.isPlaying = false
        } else {
            self.startPlayAnimation()
            // 播放
            if let _url = URL(string: audioContent.remoteUrl) {
                audioContent.isPlaying = true
                BPPlayerManager.share.playAudio(url: _url) { [weak self] in
                    guard let self = self else { return }
                    print("播放完成")
                    self.stopPlayAnimation()
                    audioContent.isPlaying = false
                }
            }
        }
    }
    
    /// 播放进度动画
    func startPlayAnimation() {
        self.animationImageView.startAnimating()
    }
    
    /// 停止进度动画
    func stopPlayAnimation() {
        self.animationImageView.stopAnimating()
    }
    
    // MARK: ==== Notification ====
    @objc
    private func playNotification(sender: Notification) {
        guard let _urlStr = sender.userInfo?["url"] as? String else {
            return
        }
        guard let audioContent = self.messageModel?.content as? RCHQVoiceMessage else {
            return
        }
        if _urlStr != audioContent.remoteUrl {
            self.stopPlayAnimation()
            audioContent.isPlaying = false
        }
    }
    
    @objc
    private func playFinishedNotification(sender: Notification) {
        guard let _urlStr = sender.userInfo?["url"] as? String else {
            return
        }
        guard let audioContent = self.messageModel?.content as? RCHQVoiceMessage else {
            return
        }
        if _urlStr == audioContent.remoteUrl {
            self.stopPlayAnimation()
            audioContent.isPlaying = false
        }
    }
}
