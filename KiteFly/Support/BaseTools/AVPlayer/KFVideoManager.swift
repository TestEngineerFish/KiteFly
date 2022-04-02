//
//  BPVideoManager.swift
//  Tenant
//
//  Created by samsha on 2021/8/13.
//

import UIKit
import AVFoundation

protocol KFVideoManagerDelegate: NSObjectProtocol {
    /// 开始播放
    func playBlock()
    /// 暂停播放
    func pauseBlock()
    /// 播放进度
    func progressBlock(progress: Double, currentSecond: Double)
    /// 状态更新
    func updateStatus(status: AVPlayerItem.Status)
}

class KFVideoManager: NSObject {
    
    private var player: AVPlayer?
    private var model: BPMediaVideoModel?
    private var contentLayer: CALayer?
    weak var delegate: KFVideoManagerDelegate?
    
    func setData(model: BPMediaVideoModel, contentLayer: CALayer) {
        self.model = model
        self.contentLayer = contentLayer
        self.setPlayer()
        self.addProgressObserver()
    }

    /// 获取播放内容
    /// - Parameter url: 播放地址
    private func getAsset() -> AVAsset? {
        guard let _model = self.model else { return nil }
        let url: URL? = {
            if let path = _model.videoLocalPath, FileManager.default.fileExists(atPath: path) {
                return URL(fileURLWithPath: path)
            } else if let path = _model.videoRemotePath {
                return URL(string: path)
            } else {
                return nil
            }
        }()
        guard let _url = url else { return nil }
        let asset = AVAsset(url: _url)
        return asset
    }
    
    private func getItem() -> AVPlayerItem? {
        guard let _asset = self.getAsset() else { return nil}
        let item = AVPlayerItem(asset: _asset)
        item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        return item
    }
    
    private func setPlayer() {
        guard let _item = self.getItem() else { return }
        self.player     = AVPlayer(playerItem: _item)
        let playLayer   = AVPlayerLayer(player: self.player!)
        playLayer.frame = kWindow.bounds
        self.contentLayer?.addSublayer(playLayer)
    }
    
    // MARK: ==== Event ====
    /// 播放
    func play() {
        guard self.player?.currentItem?.asset.isPlayable ?? false else {
            kWindow.toast("资源不可播放")
            return
        }
        // 设置进度
        if let _item = self.player?.currentItem, _item.currentTime() < _item.duration {
            self.player?.seek(to: _item.currentTime())
        } else {
            self.player?.seek(to: .zero)
        }
        self.player?.play()
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.playBlock()
        }
    }
    
    /// 暂停
    func pause() {
        self.player?.pause()
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.pauseBlock()
        }
    }
    
    /// 进度监听
    private func addProgressObserver() {
        self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .global(), using: { [weak self] timer in
            guard let self = self, let totalSecond = self.player?.currentItem?.duration.seconds, totalSecond > 0 else {
                return
            }
            let progress = timer.seconds / totalSecond
            if progress >= 1 {
                self.pause()
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.progressBlock(progress: progress, currentSecond: timer.seconds)
            }
        })
    }
    
    // MARK: ==== KVO ====
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {

            DispatchQueue.main.async { [weak self] in
                guard let self = self, let status = self.player?.currentItem?.status else {
                    return
                }
                self.delegate?.updateStatus(status: status)
            }
        }
    }
}
