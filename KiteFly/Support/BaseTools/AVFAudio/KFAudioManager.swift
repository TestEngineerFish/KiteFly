//
//  BPAudioManager.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/8/2.
//

import UIKit

import AVFoundation

@objc(BPAudioManagerDelegate)
public protocol KFAudioManagerDelegate: NSObjectProtocol {
    /// 每0.1s刷新一次
    func refreshAction(duration: TimeInterval)
    /// 录制结束
    func recordFinished(data: Data, local path: String, duration: TimeInterval)
    /// 声音回调，每0.1s刷新一次
    func updateVoice(value: Float)
}

/// 声音管理器
@objc(BPAudioManager)
open class KFAudioManager: NSObject, AVAudioRecorderDelegate {

    @objc
    static public let share = KFAudioManager()
    @objc
    public weak var delegate: KFAudioManagerDelegate?

    private let filePath = KFFileManager.share.voicePath + "/voice.aac"
    
    private var isCancel = false

    /// 录制起
    private var recorder: AVAudioRecorder?

    /// 录制完成回调
    private var recordBlock: ((Data, TimeInterval)->Void)?

    private var timer: Timer?

    /// 刷新间隔时间
    private let interval = 0.25

    /// 当前已录制秒数
    private var currentSecond: TimeInterval = .zero {
        willSet {
            self.delegate?.refreshAction(duration: newValue)
        }
    }

    deinit {
        self.stopTimer()
    }

    /// 开始录音
    /// - Parameters:
    ///   - refreshBlock: 当前已录制的时间，默认0.1s回调一次
    ///   - completeBlock: 完成录制，返回录制的音频文件和持续的时间
    @objc
    public func startRecording() {
        self.isCancel      = false
        self.currentSecond = 0
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            var setting = [String:Any]()
            //设置录音格式
            setting[AVFormatIDKey]            = NSNumber(value: kAudioFormatMPEG4AAC)
            //设置录音采样率（HZ）
            setting[AVSampleRateKey]          = NSNumber(value: 44100.0)
            //录音通道数
            setting[AVNumberOfChannelsKey]    = NSNumber(value: 2)
            //线性采样位数
            setting[AVLinearPCMBitDepthKey]   = NSNumber(value: 16)
            //录音的质量
            setting[AVEncoderAudioQualityKey] = NSNumber(value: AVAudioQuality.min.rawValue)

            let url = URL(fileURLWithPath: filePath)
            self.recorder = try AVAudioRecorder(url: url, settings: setting)
            self.recorder?.delegate = self
            //开启音量监测
            self.recorder?.isMeteringEnabled = true
            if self.recorder?.prepareToRecord() ?? false {
                self.recorder?.record()
                self.startTimer()
                print("启动录制成功")
            } else {
                print("启动录制失败")
            }
        } catch let error {
            print("\(error)")
        }
    }

    /// 停止录音
    public func stopRecording() {
        self.isCancel = false
        self.recorder?.stop()
    }

    /// 取消录音
    func cancelRecording() {
        self.isCancel = true
        self.recorder?.stop()
    }

    // MARK: ==== Event ====
    private func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.currentSecond += self.interval
            self.updateVoice()
            print(self.currentSecond)
        }
        self.timer?.fire()
    }

    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }

    private func updateVoice() {
        self.recorder?.updateMeters()
        let voice = self.getVoice()
        print("当前音量\(voice)")
        self.delegate?.updateVoice(value: voice * 10)
    }

    /// 获取音量大小
    /// - Returns: 范围0～1
    private func getVoice() -> Float {
        var level: Float = .zero
        let minV: Float  = -60
        let averageV = self.recorder?.averagePower(forChannel: 0) ?? 0
        if averageV < minV {
            level = .zero
        } else if averageV >= .zero {
            level = 1
        } else {
            let root: Float = 5.0
            let minAmp = powf(10.0, 0.05 * minV)
            let inverseAmpRange = 1.0 / (1.0 - minAmp)
            let amp = powf(10.0, 0.05 * averageV)
            let adjAmp = (amp - minAmp) * inverseAmpRange
            level = powf(adjAmp, 1.0 / root)
        }
        return level
    }

    // MARK: ==== AVAudioRecorderDelegate ====
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.stopTimer()
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return
        }
        if !isCancel {
            self.delegate?.recordFinished(data: data, local: filePath, duration: currentSecond)
        }
        recorder.deleteRecording()
    }

    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("error")
    }



}
