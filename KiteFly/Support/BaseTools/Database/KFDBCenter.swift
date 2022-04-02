//
//  BPDBCenter.swift
//  MessageCenter
//
//  Created by apple on 2021/11/8.
//  Copyright © 2021 KLC. All rights reserved.
//

import Foundation

/// 提供给外部调用的函数
class KFDBCenter: NSObject {
    
    static let share = KFDBCenter()
//    let dbThread = Thread(target: self, selector: #selector(launchRunloop), object: nil)
    
    
    override init() {
        super.init()
//        dbThread.start()
    }
    
    /// 保活
//    @objc
//    private func launchRunloop() {
//        autoreleasepool {
//            let currentRunloop = RunLoop.current
//            currentRunloop.add(NSMachPort(), forMode: .common)
//            currentRunloop.run()
//        }
//    }
    /// 查询用户信息
    /// - Parameters:
    ///   - userId: 用户ID
    func selectUserInfo(userId: Int) -> KFUserModel? {
        let userInfo = KFUserModel.share
        return userInfo
    }
}
