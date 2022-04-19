//
//  KFSystemPhotoManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/8.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import AVFoundation
import Photos.PHPhotoLibrary
import UIKit

open class KFSystemPhotoManager: TYView_ty, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc
    public static let share = KFSystemPhotoManager()
    /// 系统相机的拍照后的回调使用
    private var completeBlock: (([BPMediaModel])->Void)?
    
    /// 显示选择相机还是相册
    /// - Parameters:
    ///   - block: 选择后的回调
    ///   - maxCount: 最大选择数量
    public func show(complete block:(([BPMediaModel])->Void)?, maxCount: Int = 1) {
        KFActionSheet().addItem(title: "相册", actionBlock: {
            KFSystemPhotoManager.share.showPhoto(complete: { (modelList) in
                block?(modelList)
            }, maxCount: maxCount)
        }).addItem(title: "相机", actionBlock: {
            KFSystemPhotoManager.share.showCamera { (modelList) in
                block?(modelList)
            }
        }).show()
    }
    
    /// 显示系统相机
    /// - Parameter block: 拍照后回调
    public func showCamera(complete block:(([BPMediaModel])->Void)?) {
        BPAuthorizationManager.share.camera { [weak self] (result) in
            guard let self = self, result else { return }
            BPAuthorizationManager.share.photo { [weak self] result in
                guard let self = self, result else { return }
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.completeBlock = block
                    let vc = UIImagePickerController()
                    vc.delegate      = self
                    vc.allowsEditing = false
                    vc.sourceType    = .camera
                    UIViewController.currentNavigationController?.present(vc, animated: true, completion: nil)
                } else {
                    kWindow.toast("该设备不支持拍摄功能")
                }
            }
        }
    }
    
    /// 显示系统相册
    /// - Parameters:
    ///   - block: 选择后的回调
    ///   - maxCount: 最大选择数量
    public func showPhoto(complete block: (([BPMediaModel])->Void)?, maxCount: Int = 1) {
        BPAuthorizationManager.share.photo { (result) in
            guard result else { return }
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let vc = KFSystemPhotoViewController()
                vc.maxSelectCount = maxCount
                vc.selectedBlock = { (medioModelList) in
                    block?(medioModelList)
                }
                UIViewController.currentNavigationController?.push(vc: vc)
            } else {
                kWindow.toast("该设备不支持相册功能")
            }
        }
    }

    /// 显示系统相册，----- (主要供OC调用) ----- 
    /// - Parameters:
    ///   - block: 选择后的回调
    ///   - maxCount: 最大选择数量
    @objc
    public func showPhoto(complete block: (([UIImage])->Void)?, maxCount: Int = 1, autoPop: Bool = true, push: Bool = true) {
        BPAuthorizationManager.share.photo { (result) in
            let vc = KFSystemPhotoViewController()
            vc.maxSelectCount = maxCount
            vc.autoPop = autoPop
            vc.push = push
            vc.selectedBlock = { (medioModelList) in
                var imageList = [UIImage]()
                medioModelList.forEach { model in
                    if let imageModel = model as? BPMediaImageModel, let _image = imageModel.image {
                        imageList.append(_image)
                    }
                }
                block?(imageList)
            }
            if (push) {
                UIViewController.currentNavigationController?.push(vc: vc)
            } else {
                let controller = UINavigationController.init(rootViewController: vc)
                controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                UIViewController.currentViewController?.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: ==== UIImagePickerControllerDelegate, UINavigationControllerDelegate ====
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.completeBlock?([])
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage?
        if picker.allowsEditing {
            image = info[.editedImage] as? UIImage
        } else {
            image = info[.originalImage] as? UIImage
        }
        let model = BPMediaImageModel()
        model.image = image
        model.name = "\(Date().timeIntervalSince1970).JPG"
        self.completeBlock?([model])
        if let _image = image {
            UIImageWriteToSavedPhotosAlbum(_image, nil, nil, nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
