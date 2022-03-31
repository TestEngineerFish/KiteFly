//
//  BPAuthoriationManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/4.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Photos
import UserNotifications
import UIKit
import Contacts

public enum BPAuthorizationType: String {
    /// 相册
    case photo        = "相册"
    /// 照相机
    case camera       = "照相机"
    /// 麦克风
    case microphone   = "麦克风"
    /// 定位
    case location     = "定位"
    /// 通知
    case notification = "通知"
    /// 网络
    case network      = "网络"
    /// 通讯录
    case contact      = "通讯录"
}

@objc
public class BPAuthorizationManager: NSObject, CLLocationManagerDelegate {
    
    @objc
    public static let share = BPAuthorizationManager()
    
    // MARK: - ---获取相册权限
    @objc
    public func photo(completion:@escaping (Bool) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            completion(false)
            return
        }
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
            self.showAlert(type: .photo)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    let result = status == PHAuthorizationStatus.authorized
                    completion(result)
                    if (!result) {
                        self.showAlert(type: .photo)
                    }
                }
            })
        case .limited:
            completion(true)
        @unknown default:
            return
        }
    }
    
    // MARK: - --相机权限
    public func camera(completion:@escaping (Bool) -> Void ) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
            self.showAlert(type: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (result: Bool) in
                DispatchQueue.main.async {
                    completion(result)
                    if (!result) {
                        self.showAlert(type: .camera)
                    }
                }
            })
        @unknown default:
            return
        }
    }
    
    // MARK: - --麦克风权限
    public func authorizeMicrophoneWith(completion:@escaping (Bool) -> Void ) {
        
        let status = AVAudioSession.sharedInstance().recordPermission
        
        switch status {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
            self.showAlert(type: .microphone)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (result) in
                DispatchQueue.main.async {
                    completion(result)
                    if (!result) {
                        self.showAlert(type: .microphone)
                    }
                }
            }
        @unknown default:
            return
        }
    }
    
    // MARK: - --远程通知权限
    public func authorizeRemoteNotification(_ completion:@escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .denied || settings.authorizationStatus == .notDetermined {
                    completion(false)
                }else{
                    completion(true)
                }
            }
        }
    }
    
    private var authorizationComplet: BoolBlock?
    // MARK: ==== CLLocationManagerDelegate ====
    
    // TODO: ==== Tools ====
    private func showAlert(type: BPAuthorizationType) {
        let projectName  = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        let title        = String(format: "无法访问你的%@", type.rawValue)
        let description  = String(format: "请到设置 -> %@ -> %@，打开访问权限", projectName, type.rawValue)

        BPAlertManager.share.twoButton(title: title, description: description, leftBtnName: "取消", leftBtnClosure: nil, rightBtnName: "打开") {
            self.jumpToAppSetting()
        }.show()
    }
    
    private func jumpToAppSetting() {
        let appSetting = URL(string: UIApplication.openSettingsURLString)

        if appSetting != nil {
            if #available(iOS 10, *) {
                UIApplication.shared.open(appSetting!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appSetting!)
            }
        }
    }
}
