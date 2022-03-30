//
//  BPBaseImageView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/7.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import SDWebImage

open class BPImageView: UIImageView, BPViewDelegate {
    
    private var imageType: BPMediaImageType = .image
    
    /// 下载进度闭包
    public typealias ImageDownloadProgress   = (CGFloat) -> Void
    /// 下载完成闭包
    public typealias ImageDownloadCompletion = ((_ image: UIImage?, _ error: Error?, _ imageURL: URL?) -> Void)

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateUI()
    }
    public init() {
        super.init(frame: .zero)
        self.updateUI()
    }
    
    init(frame: CGRect, type: BPMediaImageType) {
        super.init(frame: frame)
        self.imageType = type
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        self.updateUI()
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        self.updateUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ==== BPViewDelegate ====
    open func createSubviews() {}
    
    open func bindProperty() {}
    
    open func bindData() {}
    
    open func updateUI() {}
    
    public func showImage(with imageStr: String, placeholder: UIImage? = nil, completion: ImageDownloadCompletion? = nil, downloadProgress: ImageDownloadProgress? = nil) -> Void {
        var urlStrOption: String? = imageStr
        if imageStr.hasChinese() {
            urlStrOption = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        guard let _imageStr = urlStrOption else { return }
        let imageURL = URL(string: _imageStr)
        self.sd_setImage(with: imageURL, placeholderImage: placeholder, options: .lowPriority) { receivedSize, expectedSize, targetURL in
            let progress = CGFloat(receivedSize) / CGFloat(expectedSize)
            downloadProgress?(progress)
        } completed: { _image, error, cacheType, url in
            if let _error = error {
                completion?(nil, _error, imageURL)
            } else {
                self.image = _image
                completion?(_image, nil, imageURL)
            }
        }
    }
    
    /// 设置图片。支持缓存
    /// - Parameter urlStr: 图片地址
    /// - Parameter sessionId: 会话ID
    /// - Parameter block: 完成回调
    /// - Parameter cacheName: 本地缓存名称
    public func setImage(with urlStr: String?, cacheName: String? = nil, sessionId: String? = nil, complete block: ImageBlock? = nil) {
        DispatchQueue.global().async {
            if let image = self.getLocalImage(name: cacheName, sessionId: sessionId) {
                DispatchQueue.main.async {
                    self.image = image
                    block?(image)
                }
            } else {
                guard let _urlStr = urlStr?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
                let imageURL = URL(string: _urlStr)
                DispatchQueue.main.async {
                    self.sd_setImage(with: imageURL, placeholderImage: nil, options: .lowPriority, progress: nil) { _image, error, cacheType, url in
                        if let _ = error {
                            block?(nil)
                        } else {
                            self.image = _image
                            // 异步缓存图片
                            DispatchQueue.global().async {
                                guard let _data = _image?.pngData(), let _sessionId = sessionId else {
                                    return
                                }
                                BPFileManager.share.saveSessionMedia(type: .sessionImage, name: _urlStr, sessionId: _sessionId, data: _data, userId: "")
                            }
                            block?(_image)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: ==== Event ====
    public func setCorner(radius: CGFloat) {
        self.layer.cornerRadius  = radius
        self.layer.masksToBounds = true
    }
    
    /// 设置必填图片
    public func setRequisiteImage() {
        self.image = UIImage(named: "icon_requisite")
    }
    
    /// 获取本地缓存的图片
    /// - Parameter url: 网络地址
    /// - Returns: 图片
    func getLocalImage(name: String?, sessionId: String?) -> UIImage? {
        guard let _name = name, let _sessionId = sessionId else {
            return nil
        }
        
        guard let data = BPFileManager.share.getSessionMedia(type: .sessionImage, name: _name, sessionId: _sessionId, userId: "") else { return nil }
        return UIImage(data: data)
    }
}
