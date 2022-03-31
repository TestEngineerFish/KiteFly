//
//  KFCommunityRemarkModel.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation

import ObjectMapper

struct KFCommunityRemarkModel: Mappable {
    
    var id: String = ""
    var content: String = ""
    var byUser: KFUserModel?
    var createTime: Date?
    
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        content     <- map["content"]
        byUser      <- map["byUser"]
        createTime  <- map["createTime"]
    }
}
