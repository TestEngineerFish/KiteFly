//
//  BPPlayerManager.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/8/3.
//

import UIKit
import AVFoundation

/// 声音管理器
@objc(BPPlayerManager)
open class BPPlayerManager: NSObject {

    @objc
    public static let share = BPPlayerManager()

    /// 播放器
    private var player: AVPlayer = AVPlayer()
    /// 播放状态
    @objc
    public var isPlaying: Bool  = false
    /// 资源地址
    private var urlStr: String?

    @objc
    public override init() {
        super.init()
        self.addObservers()
    }

    deinit {
        self.removeObservers()
    }

    /// 播放后回调
    private var playback: DefaultBlock?

    ///播放音频
    @objc
    public func playAudio(url: URL, finishedBlock: DefaultBlock?) {
        BPAuthorizationManager.share.authorizeMicrophoneWith { result in
            if result {
                let item = AVPlayerItem(url: url)
                if item.asset.isPlayable {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback)
                    } catch {
                        print("初始化播放器失败")
                        finishedBlock?()
                        return
                    }
                    if let error = self.player.error {
                        print("播放器加载失败:\(error)")
                        self.player = AVPlayer()
                    }
                    self.playback = finishedBlock
                    self.player.replaceCurrentItem(with: item)
                    self.player.seek(to: .zero)
                    self.player.playImmediately(atRate: 1.0)
                    self.isPlaying = true
                    self.urlStr = url.absoluteString
                } else {
                    kWindow.toast("无效音频")
                    print("无效音频: \(url.absoluteString)")
                    finishedBlock?()
                }
            }
        }
    }

    /// 停止播放
    @objc
    public func stop() {
        if isPlaying {
            self.isPlaying = false
            self.player.pause()
        }
    }

    // MARK: Observer
    /// 添加监听
    private func addObservers() {
    }

    /// 移除监听
    private func removeObservers() {
    }

    // MARK: ==== Notification ====
    /// 播放结束事件
    @objc
    private func playFinished() {
        self.isPlaying = false
        self.playback?()
    }
    
    /// 播放失败
    @objc
    private func playFail() {
        self.playback?()
    }
}
