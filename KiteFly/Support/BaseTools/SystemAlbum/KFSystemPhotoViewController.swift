//
//  BPSystemPhotoViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/8.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Photos
import UIKit

class KFSystemPhotoViewController: KFViewController, KFSystemAlbumListViewDelegate, KFSystemPhotoViewDelegate {

    /// 当前相册对象
    private var albumModel: KFPhotoAlbumModel? {
        willSet {
            self.contentView.reload(album: newValue)
        }
    }
    private var titleBackgroundView: KFView = {
        let view = KFView()
        view.backgroundColor = UIColor.gray0
        view.layer.masksToBounds      = true
        view.isUserInteractionEnabled = false
        return view
    }()
    /// 所有相册列表
    private var collectionList: [KFPhotoAlbumModel] = []
    /// 选择后的闭包回调
    var selectedBlock:(([BPMediaModel])->Void)?
    /// 最大选择数量
    var maxSelectCount: Int = 1
    ///是否自动消失
    var autoPop: Bool = true
    ///页面跳转方式
    var push: Bool = true
    /// 相册列表视图
    private var albumListView = KFSystemAlbumListView()
    /// 内容视图
    private let contentView   = KFSystemPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(contentView)
        self.view.addSubview(albumListView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
        albumListView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
        
        if let bar = self.customNavigationBar {
            bar.addSubview(titleBackgroundView)
            bar.sendSubviewToBack(titleBackgroundView)
            bar.titleLabel.font      = UIFont.iconFont(size: AdaptSize(15))
            bar.titleLabel.textColor = UIColor.black2
            titleBackgroundView.snp.makeConstraints { make in
                make.size.equalTo(CGSize.zero)
                make.center.equalTo(self.customNavigationBar!.titleLabel)
            }
            
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.albumListView.delegate     = self
        self.contentView.delegate       = self
        self.albumListView.isHidden     = true
        self.contentView.maxSelectCount = maxSelectCount
        // 点击相册名可更换其他相册
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.switchAlbumList))
        if let bar = self.customNavigationBar {
            bar.titleLabel.isUserInteractionEnabled = true
            bar.titleLabel.addGestureRecognizer(tapAction)
            // 确定选择
            bar.rightButton.setTitleColor(UIColor.white)
            bar.rightButton.layer.masksToBounds = true
            bar.leftTitle = ""
            bar.leftButton.setImage(UIImage(named: "photo_album_close_icon"), for: .normal)
            self.updateRightButtonStatus()
        }
    }

    override func bindData() {
        super.bindData()
        // 获取相册列表
        self.setAssetCollection { [weak self] in
            guard let self = self, !self.collectionList.isEmpty else {
                return
            }
            // 设置默认显示的相册
            self.albumModel = self.collectionList.first
            self.albumListView.setData(albumList: self.collectionList, current: self.albumModel)
            self.albumListView.tableView.reloadData()
            self.updateTitleView()
        }
    }
    
    override func leftAction() {
        if (self.push) {
            super.leftAction()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func rightAction() {
        super.rightAction()
        let group = DispatchGroup()
        var mediaModelList = [BPMediaModel]()
        let assetModelList = self.contentView.selectedPhotoList()
        
        self.view.showLoading()
        assetModelList.forEach { (asset) in
            group.enter()
            self.assetTransforMediaModel(asset: asset) { model in
                guard let _model = model else {
                    group.leave()
                    return
                }
                mediaModelList.append(_model)
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            var result = true
            mediaModelList.forEach { model in
                if let imageModel = model as? BPMediaImageModel, let _image = imageModel.image {
                    if (imageModel.data?.sizeMB ?? 0 > 30) {
                        kWindow.toast("部分图片太大，请重新选择")
                        result = false
                    } else if (imageModel.data?.sizeKB ?? 0 > 500) {
                        if let finalImageData = _image.compress(size: CGSize(width: 800.0, height: 800.0), compressionQuality: 0.5) {
                            imageModel.image = UIImage(data: finalImageData)
                        }
                    }
                }
            }
            self.view.hideLoading()
            if result {
                self.selectedBlock?(mediaModelList)
                if (self.autoPop) {
                    UIViewController.currentNavigationController?.pop()
                }
            }
        }
    }

    // MARK: ==== Event ====
    /// 设置相册列表
    private func setAssetCollection(complete block: DefaultBlock?) {
        BPAuthorizationManager.share.photo { [weak self] (result) in
            guard let self = self, result else { return }
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                // 收藏相册
                let favoritesCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
                // 相机照片
                let assetCollections     = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumUserLibrary, options: nil)
                // 全部照片
                let cameraRolls          = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
                var id: Int = 0
                cameraRolls.enumerateObjects { [weak self] (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    id += 1
                    let model = KFPhotoAlbumModel(collection: collection)
                    model.id = id
                    self?.collectionList.append(model)
                }
                favoritesCollections.enumerateObjects { [weak self] (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    id += 1
                    let model = KFPhotoAlbumModel(collection: collection)
                    model.id = id
                    self?.collectionList.append(model)
                }
                assetCollections.enumerateObjects { [weak self] (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    id += 1
                    let model = KFPhotoAlbumModel(collection: collection)
                    model.id = id
                    self?.collectionList.append(model)
                }
                DispatchQueue.main.async {
                    block?()
                }
            }
        }
    }
    
    @objc private func switchAlbumList() {
        if self.albumListView.isHidden {
            self.albumListView.showView()
        } else {
            self.albumListView.hideView()
        }
    }
    
    /// 更新右上角确定按钮的状态
    private func updateRightButtonStatus() {
        let list = self.contentView.selectedPhotoList()
        var title = "完成"
        if list.isEmpty {
            self.customNavigationBar?.rightButton.setStatus(.disable)
        } else {
            title += "(\(list.count)/\(self.maxSelectCount))"
            self.customNavigationBar?.rightButton.setStatus(.normal)
        }
        if let bar = self.customNavigationBar {
            bar.rightTitle = title
//            let _width = bar.rightButton.sizeThatFits(CGSize(width: kScreenWidth, height: AdaptSize(27))).width
//            let rightButtonSize = CGSize(width: _width + AdaptSize(10), height: AdaptSize(27))
//            bar.rightButton.layer.cornerRadius = rightButtonSize.height/2
//            bar.rightButton.backgroundColor    = UIColor.gradientColor(with: rightButtonSize, colors: UIColor.themeGradientList, direction: .horizontal)
        }
    }
    
    /// 更新标题
    private func updateTitleView() {
        if self.albumListView.isHidden {
            self.customNavigationBar?.title = (self.albumModel?.assetCollection?.localizedTitle ?? "") + IconFont.arrowDown.rawValue
        } else {
            self.customNavigationBar?.title = (self.albumModel?.assetCollection?.localizedTitle ?? "") + IconFont.arrowUp.rawValue
        }
        if let _titleLabel = self.customNavigationBar?.titleLabel, let _title = _titleLabel.text {
            let _width = _title.textWidth(font: _titleLabel.font, height: _titleLabel.font.lineHeight)
            let _size = CGSize(width: _width + AdaptSize(20), height: _titleLabel.font.lineHeight + AdaptSize(10))
            self.titleBackgroundView.snp.updateConstraints { make in
                make.size.equalTo(_size)
            }
            self.titleBackgroundView.layer.cornerRadius = _size.height/2
        }
    }

    // MARK: ==== Tools ====
    /// 转换得到资源对象
    private func assetTransforMediaModel(asset: PHAsset, complete block: ((BPMediaModel?)->Void)?) {
        switch asset.mediaType {
        case .image:
            self.getImage(asset: asset, complete: block)
        case .video:
            self.getVideo(asset: asset, complete: block)
        default:
            block?(nil)
            break
        }
    }
    
    /// 获取图片
    private func getImage(asset: PHAsset, complete block: ((BPMediaImageModel?)->Void)?) {
        var model: BPMediaImageModel?
        let options = PHImageRequestOptions()
        options.deliveryMode           = .highQualityFormat
        options.isSynchronous          = true
        options.resizeMode             = .exact
        options.isNetworkAccessAllowed = true
        options.progressHandler = { (progress, error, stop, userInfo:[AnyHashable : Any]?) in
            print("Progress: \(progress)")
        }
//        PHCachingImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (image: UIImage?, info:[AnyHashable : Any]?) in
//            guard let result = info as? [String: Any], (result[PHImageCancelledKey] == nil), (result[PHImageErrorKey] == nil) else {
//                block?(nil)
//                return
//            }
//            let mediaModel = BPMediaImageModel()
//            mediaModel.image = image
//            mediaModel.name  = asset.value(forKey: "filename") as? String ?? ""
//            mediaModel.type  = .image(type: .originImage)
//            model = mediaModel
//            block?(model)
//        }
        PHImageManager.default().requestImageData(for: asset, options: options) { data, str, ori, info in
            print(data?.sizeMB ?? 0)
            guard let data = data else {
                block?(nil)
                return
            }
            let mediaModel = BPMediaImageModel()
            mediaModel.image = UIImage(data: data)
            mediaModel.name  = asset.value(forKey: "filename") as? String ?? ""
            mediaModel.type  = .image(type: .originImage)
            mediaModel.data  = data
            model = mediaModel
            block?(model)
        }
    }
    
    /// 获取视频
    private func getVideo(asset: PHAsset, complete block: ((BPMediaModel?)->Void)?) {
        guard let resource = PHAssetResource.assetResources(for: asset).first else {
            block?(nil)
            return
        }
        var videoData: Data?
        let option = PHAssetResourceRequestOptions()
        option.isNetworkAccessAllowed = true
        
        PHAssetResourceManager.default().requestData(for: resource, options: option) { data in
            videoData = data
        } completionHandler: { error in
            guard error == nil, let _data = videoData else {
                block?(nil)
                return
            }
            let model = BPMediaVideoModel()
            model.data = _data
            model.name = resource.originalFilename
            model.type = .video
            block?(model)
        }
    }
    
    // MARK: ==== BPSystemPhotoViewDelegate ====
    func clickImage(indexPath: IndexPath, from imageView: UIImageView?) {
        guard let model = self.albumModel else { return }
        KFBrowserView(type: .system(result: model.assets), current: indexPath.row).show(animationView: imageView)
    }
    
    func selectedImage() {
        self.updateRightButtonStatus()
    }
    func unselectImage() {
        self.updateRightButtonStatus()
    }

    // MARK: ==== BPSystemAlbumListViewDelegate ====
    func selectedAlbum(model: KFPhotoAlbumModel?) {
        self.albumModel = model
        self.updateTitleView()
    }
    
    func showAlbumAction() {
        self.updateTitleView()
    }
    
    func hideAlbumAction() {
        self.updateTitleView()
    }

}
