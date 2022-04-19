//
//  BPSystemPhotoView.swift
//  Tenant
//
//  Created by samsha on 2021/2/10.
//

import Photos
import UIKit

protocol KFSystemPhotoViewDelegate: NSObjectProtocol {
    func clickImage(indexPath: IndexPath, from imageView: UIImageView?)
    func selectedImage()
    func unselectImage()
}

class KFSystemPhotoView: TYView_ty, UICollectionViewDelegate, UICollectionViewDataSource, KFPhotoAlbumCellDelegate {
    
    weak var delegate: KFSystemPhotoViewDelegate?
    private let kBPPhotoAlbumCellID = "kBPPhotoAlbumCell"
    /// 当前相册对象
    private var albumModel: KFPhotoAlbumModel?
    /// 已选中的资源
    private var selectedList: [PHAsset] = []
    /// 最大选择数量
    var maxSelectCount: Int = 1
    
    /// 照片列表
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width  = kScreenWidth / 4
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing      = .zero
        layout.minimumInteritemSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(KFMediaCell.classForCoder(), forCellWithReuseIdentifier: self.kBPPhotoAlbumCellID)
    }
    
    // MARK: ==== Event ====
    
    func reload(album model: KFPhotoAlbumModel?) {
        self.albumModel = model
        self.collectionView.reloadData()
    }
    
    /// 获取已选择照片列表
    func selectedPhotoList() -> [PHAsset] {
        return self.selectedList
    }
    
    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumModel?.assets.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBPPhotoAlbumCellID, for: indexPath) as? KFMediaCell, let asset = self.albumModel?.assets[indexPath.row] else {
            return KFCollectionViewCell()
        }
        let selected    = self.selectedList.contains(asset)
        let selectedMax = self.selectedList.count >= maxSelectCount
        cell.setData(asset: asset, isSelected: selected, selectedMax: selectedMax)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? KFMediaCell else {
            return
        }
        self.delegate?.clickImage(indexPath: indexPath, from: cell.imageView)
    }
    
    
    // MARK: ==== BPPhotoAlbumCellDelegate ====
    func selectedImage(model: Any) {
        guard let _model = model as? PHAsset,
              !self.selectedList.contains(_model),
              self.selectedList.count < maxSelectCount else {
                  return
              }
        self.selectedList.append(_model)
        self.collectionView.reloadData()
        self.delegate?.selectedImage()
    }

    func unselectImage(model: Any) {
        guard let _model = model as? PHAsset, let index = self.selectedList.firstIndex(of: _model) else { return }
        self.selectedList.remove(at: index)
        self.collectionView.reloadData()
        self.delegate?.unselectImage()
    }
    
    func selectedExcess() {
        kWindow.toast("您最多可以上传\(maxSelectCount)张图片")
    }
}

