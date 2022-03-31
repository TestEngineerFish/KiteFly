//
//  BPPhotoAlbumCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/4.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Photos
import UIKit

protocol BPPhotoAlbumCellDelegate: NSObjectProtocol {
    func selectedImage(model: Any)
    func unselectImage(model: Any)
    /// 超额选择
    func selectedExcess()
}

class BPMediaCell: BPCollectionViewCell {
    /// 历史照片列表使用
    var model: BPMediaModel?
    /// 系统相册列表使用
    var assetMode: PHAsset?

    weak var delegate: BPPhotoAlbumCellDelegate?

    private var disableShadowView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        view.isHidden        = true
        return view
    }()
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private var selectedBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.isHidden = true
        return view
    }()

    private var iconLabel: UILabel = {
        let label = UILabel()
        label.text          = IconFont.video.rawValue
        label.textColor     = UIColor.white
        label.font          = UIFont.iconFont(size: AdaptSize(18))
        label.textAlignment = .center
        label.isHidden      = true
        return label
    }()
    private var iconImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private var timeLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptSize(10))
        label.textAlignment = .left
        label.isHidden      = true
        return label
    }()

    private var selectButton: BPButton = {
        let button = BPButton()
        button.setImage(UIImage(named: "unselectImage"), for: .normal)
        button.setImage(UIImage(named: "selectedImage"), for: .selected)
        return button
    }()

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
        self.addSubview(imageView)
        self.addSubview(selectedBgView)
        self.addSubview(selectButton)
        self.addSubview(iconLabel)
        self.addSubview(timeLabel)
        self.addSubview(disableShadowView)
        imageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(0.9)
            make.right.bottom.equalToSuperview().offset(-0.9)
        }
        selectedBgView.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView)
        }
        selectButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(AdaptSize(35))
        }
        iconLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(5))
            make.bottom.equalToSuperview().offset(AdaptSize(-5))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(18)))
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconLabel.snp.right).offset(AdaptSize(5))
            make.centerY.equalTo(iconLabel)
            make.right.equalToSuperview().offset(AdaptSize(-10))
            make.height.equalTo(AdaptSize(10))
        }
        disableShadowView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    internal override func bindProperty() {
        super.bindProperty()
        self.imageView.layer.masksToBounds = true
        self.selectButton.addTarget(self, action: #selector(selectedImage(sender:)), for: .touchUpInside)
        let tapDisableGes = UITapGestureRecognizer(target: self, action: #selector(boredAction))
        self.disableShadowView.addGestureRecognizer(tapDisableGes)
    }

    // MARK: ==== Event ====
    @objc
    private func boredAction() {
        self.delegate?.selectedExcess()
    }
    
    /// 显示历史照片浏览
    func setData(model: BPMediaModel, hideSelect: Bool, isSelected: Bool) {
        self.model                   = model
        self.isSelected              = isSelected
        self.selectButton.isHidden   = hideSelect
        self.selectedBgView.isHidden = hideSelect
        
        switch model.type {
        case .video:
            self.iconLabel.isHidden = false
            self.timeLabel.isHidden = false
            self.iconLabel.text = IconFont.video.rawValue
//            if let videoModel = model as? BPMediaVideoModel {
//                self.timeLabel.text = videoModel.time.minuteSecondStr()
//                videoModel.getCover(progress: nil) { [weak self] image in
//                    self?.imageView.image = image
//                }
//            }
        case .audio:
            self.iconLabel.isHidden = false
            self.timeLabel.isHidden = false
            self.iconLabel.text = IconFont.audio.rawValue
            self.timeLabel.text = ""
        case .image:
            self.iconLabel.isHidden = true
            self.timeLabel.isHidden = true
            self.iconLabel.text = ""
            self.timeLabel.text = ""
//            if let imageModel = model as? BPMediaImageModel {
//                imageModel.getImage(progress: nil) {[weak self] (image: UIImage?) in
//                    self?.imageView.image = image
//                }
//            }
        default:
            break
        }
    }

    /// 显示系统相册中的照片
    func setData(asset: PHAsset, isSelected: Bool, selectedMax: Bool) {
        self.assetMode               = asset
        self.selectButton.isSelected = isSelected
        self.selectedBgView.isHidden = !isSelected
        self.imageView.image         = nil
        self.timeLabel.text          = asset.duration.minuteSecondStr()
        if selectedMax && !isSelected {
            self.disableShadowView.isHidden = false
        } else {
            self.disableShadowView.isHidden = true
        }
        
        if asset.mediaType == .video || asset.mediaType == .audio {
            self.iconLabel.isHidden = false
            self.timeLabel.isHidden = false
        } else {
            self.iconLabel.isHidden = true
            self.timeLabel.isHidden = true
        }
        
        self.iconLabel.text = {
            if asset.mediaType == .video {
                return IconFont.video.rawValue
            } else if asset.mediaType == .audio {
                return IconFont.audio.rawValue
            } else {
                return ""
            }
        }()
        self.timeLabel.text = {
            if Int(asset.duration) >= hour {
                return asset.duration.hourMinuteSecondStr()
            } else {
                return asset.duration.minuteSecondStr()
            }
        }()
        let imageSize = (kScreenWidth - 20) / 5.5 * UIScreen.main.scale
        let options   = PHImageRequestOptions()
        options.isSynchronous = false
        PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: imageSize, height: imageSize), contentMode: .default, options: options) { [weak self] (image: UIImage?, info:[AnyHashable : Any]?) in
            self?.imageView.image = image
        }
    }

    @objc private func selectedImage(sender: BPButton) {
        let _isSelected = !sender.isSelected
        var imageModel: Any
        if let _model = self.model {
            imageModel = _model
        } else if let _model = self.assetMode {
            imageModel = _model
        } else {
            return
        }
        if _isSelected {
            self.delegate?.selectedImage(model: imageModel)
        } else {
            self.delegate?.unselectImage(model: imageModel)
        }
    }

}
