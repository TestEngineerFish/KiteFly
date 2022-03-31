//
//  KFUserModel.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation

import ObjectMapper

enum KFSex: Int {
    case man     = 0
    case woman   = 1
    case unknown = 3
    
    var str: String {
        switch self {
        case .man:
            return "男"
        case .woman:
            return "女"
        case .unknown:
            return "保密"
        }
    }
}

struct KFUserModel: Mappable {
    
    var id: String      = ""
    var avatar: String  = ""
    var name: String    = ""
    var age: Int        = 0
    var sex: KFSex      = .unknown
    var remark: String  = ""
    var address: String = ""
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id      <- map["id"]
        avatar  <- map["avatar"]
        name    <- map["name"]
        age     <- map["age"]
        sex     <- (map["sex"], EnumTransform<KFSex>())
        remark  <- map["remark"]
        address <- map["address"]
    }
}
