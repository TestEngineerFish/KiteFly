//
//  KFHomePageModel.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation

import ObjectMapper

struct KFHomePageModel: Mappable {
    
    var url: String   = ""
    var image: String = ""
    var title: String = ""
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        url   <- map["url"]
        image <- map["image"]
        title <- map["title"]
    }
}
