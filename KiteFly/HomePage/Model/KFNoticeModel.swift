//
//  KFNoticeModel.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import ObjectMapper

/// 放风筝的新闻
struct KFNoticeModel: Mappable {
    
    var id: String?
    var icon: String    = ""
    /// 发布时间
    var time: Date?
    /// 截止时间
    var lastTime: Date?
    var title: String   = ""
    /// 发布者
    var name: String?
    /// 具体内容
    var content: String = ""
    /// 报名人数
    var amount = 0
    /// 联系方式
    var contact: String = ""
    /// 地址
    var address: String = ""
    /// 是否已报名
    var isRegister: Bool = false
    /// 备注
    var remark: String = ""
    
    
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        icon    <- map["icon"]
        time    <- map["time"]
        lastTime <- map["lastTime"]
        title   <- map["title"]
        content <- map["content"]
        amount <- map["amount"]
        contact <- map["contact"]
        address <- map["address"]
        isRegister <- map["isRegister"]
        remark <- map["remark"]
        name <- map["name"]
    }
}

