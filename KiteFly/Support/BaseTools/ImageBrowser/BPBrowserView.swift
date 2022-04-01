//
//  BPBrowserView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/1.
//  Copyright © 2020 沙庭宇. All rights reserved.
//
import UIKit
import Photos

public enum BPImageBrowserType {
    /// 自定义
    case custom(modelList: [BPMediaModel])
    /// 系统相册
    case system(result: [PHAsset])
}

public protocol BPImageBrowserDelegate:NSObjectProtocol {
    func reuploadImage(model:[BPMediaModel])
}

public class BPBrowserView:
    BPView,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    BPBrowserImageCellDelegate,
    BPBrowserVideoCellDelegate {
    
    public weak var delegate:BPImageBrowserDelegate?
    
    private let kBPBrowserImageCellID = "kBPBrowserImageCellID"
    private let kBPBrowserVideoCellID = "kBPBrowserVideoCellID"
    private var medioModelList: [BPMediaModel] = []
    private var assetModelList: PHFetchResult<PHAsset>?
    private var type: BPImageBrowserType
    private var currentIndex: Int
    private var startFrame: CGRect?
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize           = kWindow.size
        layout.scrollDirection    = .horizontal
        layout.minimumLineSpacing = .zero
//        layout.minimumInteritemSpacing = AdaptSize(20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.isPagingEnabled  = true
        collectionView.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: .flexibleWidth, .flexibleHeight)
        collectionView.backgroundColor  = .clear
        collectionView.isHidden         = true
        return collectionView
    }()
    
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    private var albumButton: BPButton = {
        let button = BPButton()
        button.setTitle("全部", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font   = UIFont.regularFont(ofSize: AdaptSize(14))
        button.backgroundColor    = UIColor.black0.withAlphaComponent(0.9)
        button.layer.cornerRadius = AdaptSize(5)
        button.isHidden           = true
        return button
    }()
    
    public init(type: BPImageBrowserType, current index: Int) {
        self.type         = type
        self.currentIndex = index
        super.init(frame: .zero)
        self.createSubviews()
        self.bindProperty()
        self.bindData()
        self.updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.addSubview(backgroundView)
        self.addSubview(collectionView)
        
        self.addSubview(albumButton)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        albumButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(40))
            make.right.equalToSuperview().offset(-AdaptSize(20))
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(25)))
        }
    }
    
    public override func bindProperty() {
        super.bindProperty()
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(BPBrowserImageCell.classForCoder(), forCellWithReuseIdentifier: kBPBrowserImageCellID)
        self.collectionView.register(BPBrowserVideoCell.classForCoder(), forCellWithReuseIdentifier: kBPBrowserVideoCellID)
        self.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: .flexibleHeight, .flexibleWidth)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.scrollToCurrentPage()
        }
        self.albumButton.addTarget(self, action: #selector(self.showAlubmVC), for: .touchUpInside)
    }
    
    public override func bindData() {
        super.bindData()
        self.collectionView.reloadData()
    }
    
    public override func updateUI() {
        super.updateUI()
        self.backgroundColor = .clear
    }
    
    // MARK: ==== Animation ====
    private func showAnimation(startView: UIImageView) {
        self.startFrame = startView.convert(startView.bounds, to: kWindow)
        // 做动画的视图
        let imageView = UIImageView()
        imageView.frame       = startFrame ?? CGRect(origin: .zero, size: kWindow.size)
        imageView.image       = startView.image
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        self.collectionView.isHidden = true
        UIView.animate(withDuration: 0.25) {
            imageView.frame = CGRect(origin: .zero, size: kWindow.size)
        } completion: { [weak self] (finished) in
            if (finished) {
                imageView.removeFromSuperview()
                self?.collectionView.isHidden = false
            }
        }
    }
    
    private func hideAnimation(view: UIView) {
        guard let startFrame = self.startFrame else {
            self.hide()
            return
        }
        let imageView = UIImageView()
        imageView.frame       = view.frame
        imageView.image       = view.toImage()
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        self.collectionView.isHidden = true
        UIView.animate(withDuration: 0.25) { [weak self] in
            imageView.frame = startFrame
            self?.backgroundView.layer.opacity = 0.0
        } completion: { [weak self] (finished) in
            guard let self = self else { return }
            if (finished) {
                imageView.removeFromSuperview()
                self.layer.opacity = 0.0
                self.hide()
            }
        }
    }
    
    // MARK: ==== Event ====
    
    /// 显示入场动画
    /// - Parameter animationView: 动画参考对象
    public func show(animationView: UIImageView?) {
        UIViewController.currentViewController?.view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        guard let imageView = animationView else {
            return
        }
        // 显示进入动画
        self.showAnimation(startView: imageView)
    }
    
    @objc
    public func hide() {
        self.removeFromSuperview()
    }
    
    @objc
    private func showAlubmVC() {
        let vc = BPPhotoAlbumViewController()
        vc.modelList = self.medioModelList
        UIViewController.currentNavigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: ==== Tools ====
    private func scrollToCurrentPage() {
        let offsetX = kWindow.width * CGFloat(self.currentIndex)
        self.collectionView.contentOffset = CGPoint(x: offsetX, y: 0)
    }
    
    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .custom(let modelList):
            return modelList.count
        case .system(let result):
            return result.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch type {
        case .custom(let modelList):
            let model = modelList[indexPath.row]
            switch model.type {
            case .image:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBPBrowserImageCellID, for: indexPath) as? BPBrowserImageCell, let imageModel = model as? BPMediaImageModel else {
                    return BPCollectionViewCell()
                }
                cell.delegate = self
                cell.setCustomData(model: imageModel, userId: "")
                return cell
            case .video:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBPBrowserVideoCellID, for: indexPath) as? BPBrowserVideoCell, let videoModel = model as? BPMediaVideoModel else {
                    return BPCollectionViewCell()
                }
                cell.setData(model: videoModel)
                cell.delegate = self
                return cell
            default:
                return BPBrowserImageCell()
            }
        case .system(let result):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBPBrowserImageCellID, for: indexPath) as? BPBrowserImageCell else {
                return BPCollectionViewCell()
            }
            cell.delegate = self
            let asset: PHAsset = result[indexPath.row]
            cell.setSystemData(asset: asset)
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? BPBrowserImageCell)?.updateZoomScale()
    }
    
    // 滑动结束通知Cell
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
    // MARK: ==== BPBrowserVideoCellDelegate ====
    func videoViewClosedAction(view: UIView) {
        if self.startFrame != nil {
            self.hideAnimation(view: view)
        } else {
            self.hide()
        }
    }
    
    func videoViewLongPressAction(model: BPMediaVideoModel?) {
        print("保存视频暂未适配")
    }
    
    @objc private func savedVideoFinished() {
        print("保存成功")
    }
    
    // MARK: ==== BPImageBrowserCellDelegate ====
    public func clickAction(view: UIView) {
        if self.startFrame != nil {
            self.hideAnimation(view: view)
        } else {
            self.hide()
        }
    }
    
    public func longPressAction(image: UIImage?) {
        BPActionSheet().addItem(title: "保存") {
            guard let image = image else {
                return
            }
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { (result, error) in
                DispatchQueue.main.async {
                    if result {
                        kWindow.toast("保存成功")
                    } else {
                        kWindow.toast("保存失败")
                        print("保存照片失败")
                    }
                }
            }
        }.show()
        
    }
    
    public func scrolling(reduce scale: Float) {
        self.backgroundView.layer.opacity = scale
    }
    
    public func closeAction(view: UIView) {
        if self.startFrame != nil {
            self.hideAnimation(view: view)
        } else {
            self.hide()
        }
    }
}
