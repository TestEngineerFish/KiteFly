//
//  BPBrowserImageCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/2.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit
import Photos

protocol BPBrowserImageCellDelegate: NSObjectProtocol {
    func clickAction(view: UIView)
    func longPressAction(image: UIImage?)
    func scrolling(reduce scale: Float)
    func closeAction(view: UIView)
}

class BPBrowserImageCell: BPCollectionViewCell, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    /// 手指离开后，超过该值则关闭视图
    private let maxOffsetY: CGFloat     = 100
    /// 最大滑动缩放范围
    private let maxScaleY: CGFloat      = AdaptSize(1000)
    /// 拖动最小缩放比例
    private let drawMinScale: CGFloat   = 0.5
    /// 放大最大比例
    private let zoomUpMaxScal: CGFloat  = 10
    /// 放大最小比例
    private let zoomUpMinScal: CGFloat  = 2
    
    weak var delegate: BPBrowserImageCellDelegate?
    private var panGes: UIPanGestureRecognizer?
    /// 页面是否在滑动中
    private var isScrolling     = false
    /// 当前放大比例
    private var scale: CGFloat  = 1 {
        willSet {
            print("被修改了：\(newValue)")
        }
    }

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.zoomScale        = 1
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 1
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator   = false
        return scrollView
    }()
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private var progressView = BPProgressView(type: .round, size: CGSize(width: AdaptSize(60), height: AdaptSize(60)), lineWidth: AdaptSize(5))

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func createSubviews() {
        super.createSubviews()
        self.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(progressView)
        scrollView.frame = CGRect(origin: .zero, size: kWindow.size)
        imageView.frame  = CGRect(origin: .zero, size: kWindow.size)
        scrollView.contentSize = kWindow.size
        progressView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(progressView.size)
        }
    }

    internal override func bindProperty() {
        super.bindProperty()
        self.scrollView.delegate = self
        self.backgroundColor     = .clear
        self.progressView.isHidden = true
        self.configGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(didEndScroll), name: Notification.Name("kScrollDidEndDecelerating"), object: nil)
    }
    
    /// 配置手势
    private func configGesture() {
        let tapGes       = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        tapGes.numberOfTapsRequired    = 1
        tapGes.numberOfTouchesRequired = 1
        let doubleTapGes = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(sender:)))
        doubleTapGes.numberOfTapsRequired    = 2
        doubleTapGes.numberOfTouchesRequired = 1
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(sender:)))
        self.panGes = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(sender:)))
        self.panGes?.maximumNumberOfTouches = 1
        self.imageView.addGestureRecognizer(tapGes)
        self.imageView.addGestureRecognizer(doubleTapGes)
        self.addGestureRecognizer(longPressGes)
        self.imageView.addGestureRecognizer(panGes!)
        panGes?.delegate = self
        tapGes.require(toFail: doubleTapGes)
    }

    // MARK: ==== Event ====

    func setCustomData(model: BPMediaImageModel, userId: String) {
        self.getOriginImage(model: model, progress: nil, completion: { [weak self] (image: UIImage?) in
            guard let self = self else { return }
            self.imageView.image = image
            self.updateZoomScale()
        }, userId: userId)
    }
    
    func setSystemData(asset: PHAsset) {
        asset.toMediaImageModel { [weak self] progress in
            guard let self = self, let _progress = progress else { return }
            self.progressView.isHidden = false
            self.progressView.setProgress(progress: CGFloat(_progress))
            self.progressView.isHidden = _progress >= 1
        } completeBlock: { model in
            self.imageView.image = model.image
            self.updateZoomScale()
        }
    }
    
    private func resetScale() {
        self.imageView.frame        = self.bounds
        self.scrollView.contentSize = self.bounds.size
    }

    @objc private func didEndScroll() {
//        self.resetScale()
    }

    /// 点击手势事件
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        self.delegate?.clickAction(view: self.imageView)
    }
    
    /// 双击手势事件
    @objc private func doubleTapAction(sender: UITapGestureRecognizer) {
        var _point: CGPoint = sender.location(in: self.imageView)
        let _scale: CGFloat = self.scale >= 2 ? 1 : 2
        var _rect = self.bounds
        if _scale == 2 {
            _point = CGPoint(x: imageView.width - _point.x, y: imageView.height - _point.y)
            _rect  = self.getZoomRect(scale: _scale, center: _point)
        }
        self.scrollView.contentSize  = _rect.size
        self.scrollView.contentInset = UIEdgeInsets(top: abs(_rect.origin.y), left: abs(_rect.origin.x), bottom: _rect.origin.y, right: _rect.origin.x)
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.imageView.frame        = _rect
        } completion: { [weak self] finished in
            guard let self = self else { return }
            self.scale = _scale
        }
    }
    
    private func getZoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        let _height = self.height * scale
        let _width  = self.width * scale
        let _x      = center.x - _width/2
        let _y      = center.y - _height/2
        return CGRect(x: _x, y: _y, width: _width, height: _height)
    }

    /// 长按手势事件
    @objc private func longPressAction(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.delegate?.longPressAction(image: self.imageView.image)
        }
    }
    
    private var originPoint = CGPoint.zero
    /// 滑动手势
    @objc private func panAction(sender: UIPanGestureRecognizer) {
        if self.scale > 1 {
            guard sender.state == .ended else { return }
            print(self.imageView.frame)
//            if self.scrollView.contentOffset.y < AdaptSize(-200) {
//                self.delegate?.closeAction(imageView: self.imageView)
//            }
        } else {
            let point = sender.translation(in: self)
            switch sender.state {
            case .began:
                self.originPoint = point
            case .changed:
                guard point.y > 10, !isScrolling else {
                    return
                }
                let scale: CGFloat = {
                    if point.y > self.maxScaleY {
                        return self.drawMinScale
                    } else {
                        let _scale = (self.maxScaleY - point.y) / self.maxScaleY
                        return _scale > self.drawMinScale ? _scale : self.drawMinScale
                    }
                }()
                self.delegate?.scrolling(reduce: Float(scale))
                // a:控制x轴缩放；d：控制y轴缩放；
                self.imageView.transform = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: point.x, ty: point.y)
            case .ended:
                if point.y - originPoint.y > self.maxOffsetY {
                    self.delegate?.closeAction(view: self.imageView)
                } else {
                    UIView.animate(withDuration: 0.15) { [weak self] in
                        self?.imageView.transform = .identity
                    }
                }
            default:
                return
            }
        }
    }
    /// 更新图片放大比例
    func updateZoomScale() {
        guard let _image = self.imageView.image else { return }
        let imageSize   = _image.size.width * _image.size.height
        let currentSize = self.width * height
        var scale = imageSize / currentSize
        guard scale > 1 else { return }
        scale = scale < zoomUpMinScal ? zoomUpMinScal : scale
        scale = scale > zoomUpMaxScal ? zoomUpMaxScal : scale
        self.scrollView.maximumZoomScale = scale
    }
    
    /// 显示原图，如果本地不存在则通过远端下载
    /// - Parameters:
    ///   - progress: 下载远端缩略图的进度
    ///   - completion: 下载、加载图片完成回调
    private func getOriginImage(model: BPMediaImageModel, progress: ((CGFloat) ->Void)?, completion: ((UIImage?)->Void)?, userId: String) {
        if let image = model.image {
            completion?(image)
            return
        }
        if let _sessionId = model.sessionId, _sessionId.isNotEmpty,
           let imageData = BPFileManager.share.getSessionMedia(type: .sessionImage, name: model.originLocalPath!, sessionId: _sessionId, userId: userId){
            // 如果是聊天室查看
            completion?(UIImage(data: imageData))
        } else {
            if let _path = model.originLocalPath, let image = UIImage(contentsOfFile: _path) {
                completion?(image)
            } else if let path = model.originRemotePath {
                BPDownloadManager.share.image(urlStr: path, progress: progress, completion: completion)
            } else {
                completion?(nil)
            }
        }
    }
    
    // MARK: ==== UIScrollViewDelegate ====
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var frame = self.imageView.frame
        frame.origin.y = scrollView.height - imageView.height > 0 ? (scrollView.height - imageView.height)/2 : 0
        frame.origin.x  = scrollView.width - imageView.width > 0 ? (scrollView.width - imageView.width)/2 : 0
        self.imageView.frame         = frame
        self.scrollView.contentSize  = frame.size
        self.scrollView.contentInset = .zero
        self.scale = frame.width / self.width
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // 防止过多缩小
        if self.scale < 1 {
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self = self else { return }
                self.imageView.frame        = self.bounds
                self.scrollView.contentSize = self.size
            } completion: { [weak self] finished in
                guard let self = self else { return }
                self.scale = 1
            }
        }
    }
    
    // MARK: ==== UIGestureRecognizerDelegat ====
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
