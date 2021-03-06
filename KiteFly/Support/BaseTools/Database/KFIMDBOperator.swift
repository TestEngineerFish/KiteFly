//
//  BPIMDBOperator.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import FMDB
import CoreGraphics

protocol KFIMDBProtocol {
    // 单例操作对象
    static var share: KFIMDBOperator { get }
    
    // MARK: ==== 同步操作 ====
    
    func selectUserInfo(userID: Int) -> KFUserModel?

}

extension KFIMDBProtocol {
    static var share: KFIMDBOperator { return KFIMDBOperator() }
}

class KFIMDBOperator: KFIMDBProtocol, KFDatabaseProtocol {
    
    
    /// 查询用户信息
    /// - Parameter userID: 用户ID
    /// - Returns: 用户信息
    func selectUserInfo(userID: Int) -> KFUserModel? {
        let sql    = KFSQLManager.NormalSQLs.selectUserInfo.rawValue
        let result = self.normalRunner.executeQuery(sql, withArgumentsIn: [userID])
        let model  = KFUserModel.share
        result?.close()
        return model
    }
    
    // MARK: === ASYN ====
    
    /// 更新用户姓名
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - name: 用户名
    func asynUpdateUserName(userId: Int, name: String, complete block: BoolBlock?) {
        self.normalRunnerQueue?.inDatabase({ db in
            db.open()
            let selectSql = KFSQLManager.NormalSQLs.selectUserInfo.rawValue
            let result    = db.executeQuery(selectSql, withArgumentsIn: ["\(userId)"])
            
            if let result = result, result.next() == .some(true) {
                // 更新
                let updateSql  = KFSQLManager.NormalSQLs.updateUserName.rawValue
                let parameters = [name, "\(userId)"] as [Any]
                let result = db.executeUpdate(updateSql, withArgumentsIn: parameters)
                if !result {
                    block?(false)
                    print("更新用户姓名失败：\(userId)")
                }
            } else {
                // 插入
                let insertSql  = KFSQLManager.NormalSQLs.insertUserName.rawValue
                let parameters = ["\(userId)", name] as [Any]
                let result = db.executeUpdate(insertSql, withArgumentsIn: parameters)
                if !result {
                    block?(false)
                    print("插入用户姓名失败：\(userId)")
                }
            }
            block?(true)
            db.close()
        })
    }
    
    /// 更新用户备注名称
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - name: 用户备注
    func asynUpdateUserRemarkName(userId: Int, remark name: String, complete block: BoolBlock?) {
        self.normalRunnerQueue?.inDatabase({ db in
            db.open()
            let selectSql = KFSQLManager.NormalSQLs.selectUserInfo.rawValue
            let result    = db.executeQuery(selectSql, withArgumentsIn: ["\(userId)"])
            
            if let result = result, result.next() == .some(true) {
                // 更新
                let updateSql  = KFSQLManager.NormalSQLs.updateUserRemarkName.rawValue
                let parameters = [name, "\(userId)"] as [Any]
                let result = db.executeUpdate(updateSql, withArgumentsIn: parameters)
                if !result {
                    block?(false)
                    print("更新用户备注名失败：\(userId)")
                }
            } else {
                // 插入
                let insertSql  = KFSQLManager.NormalSQLs.insertUserRemarkName.rawValue
                let parameters = ["\(userId)", name] as [Any]
                let result = db.executeUpdate(insertSql, withArgumentsIn: parameters)
                if !result {
                    block?(false)
                    print("插入用户备注名失败：\(userId)")
                }
            }
            block?(true)
            db.close()
        })
    }
}
