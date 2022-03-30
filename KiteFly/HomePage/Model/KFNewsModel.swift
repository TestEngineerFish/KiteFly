//
//  KFNewsModel.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import ObjectMapper

/// 放风筝的新闻
struct KFNewsModel: Mappable {
    
    var icon: String    = ""
    var time: Date?
    var title: String   = ""
    var content: String = ""
    var isFollow = false
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        icon    <- map["icon"]
        time    <- map["time"]
        title   <- map["title"]
        content <- map["content"]
        isFollow <- map["isFollow"]
    }
}
