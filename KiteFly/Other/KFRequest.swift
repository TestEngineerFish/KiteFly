//
//  KFRequest.swift
//  KiteFly
//
//  Created by apple on 2022/4/19.
//

import Foundation

import STYKit

enum KFRequest: TYRequest_ty {
    case sendLog(msg: String)
    
    var method_ty: TYHTTPMethod_ty {
        switch self {
        case .sendLog:
            return .post_ty
        }
    }
    
    var parameters_ty: [String : Any?]? {
        switch self {
        case .sendLog(let msg):
            return  ["msgtype": "text","text": ["content":"【FlyKite】通知：\(msg)"]]
        }
    }
    
    var path_ty: String {
        switch self {
        case .sendLog:
            return "/robot/send?access_token=ce9a301a2ecf61146066a9bdf0e1f8795e86e69a7085c58e78bcdb86204dd93e"
        }
    }
}

