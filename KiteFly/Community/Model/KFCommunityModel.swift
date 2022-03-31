//
//  KFCommunityModel.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation

import ObjectMapper

struct KFCommunityModel: Mappable {
    
    var id: String          = ""
    var userModel: KFUserModel?
    var content: String     = ""
    var imageList: [String] = []
    var remarkList: [KFCommunityRemarkModel] = []
    
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        userModel   <- map["userModel"]
        content     <- map["content"]
        imageList   <- map["imageList"]
        remarkList  <- map["remarkList"]
    }
}
