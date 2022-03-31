//
//  PHAsset+Extension.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/2/14.
//

import Photos
import UIKit

public extension PHAsset {
    /// 转换得到资源对象
    func toMediaImageModel(progressBlock: DoubleBlock?, completeBlock: ((BPMediaImageModel)->Void)?) {
        let options = PHImageRequestOptions()
        options.isSynchronous          = true
        options.resizeMode             = .fast
        options.isNetworkAccessAllowed = true
        options.deliveryMode           = .highQualityFormat
        options.progressHandler = { (progress, error, stop, userInfo:[AnyHashable : Any]?) in
            DispatchQueue.main.async {
                progressBlock?(progress)
            }
        }
        let model = BPMediaImageModel()
        let requestId: PHImageRequestID = PHCachingImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (image: UIImage?, info:[AnyHashable : Any]?) in
            guard let result = info as? [String: Any], (result[PHImageCancelledKey] == nil), (result[PHImageErrorKey] == nil) else {
                return
            }
            
            model.image = image
            completeBlock?(model)
        }
        model.id = "\(requestId)"
    }
    
    func toMediaVideoModel(progressBlock: DoubleBlock?, completeBlock: ((BPMediaVideoModel)->Void)?) {
        
    }
}
