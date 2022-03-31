//
//  BPPhotoAlbumModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/10.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper
import Photos

public class BPPhotoAlbumModel: NSObject {
    public var id: Int = 0
    public var assets  = [PHAsset]()
    public var assetCollection: PHAssetCollection?
    public convenience init(collection: PHAssetCollection) {
        self.init()
        self.assetCollection = collection
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let _assets = PHAsset.fetchAssets(in: collection, options: options)
        _assets.enumerateObjects { _asset, index, pointer in
            if let _name = _asset.value(forKey: "filename") as? String {
                if !_name.lowercased().hasSuffix(".gif") {
                    self.assets.append(_asset)
                }
            }
        }
    }
    override init() {}
    
}
