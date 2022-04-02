//
//  BPSQLManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

public struct KFSQLManager {

    /// 初始化普通数据时,构造的表结构
    public static let createNormalTables = [CreateNormalTableSQLs.userInfo.rawValue]

    // MARK: 创建表
    /// 创建普通数据的所需要的表结构
    enum CreateNormalTableSQLs: String {
        case userInfo =
        """
        CREATE TABLE IF NOT EXISTS bp_user_info(serial integer primary key, user_id text, real_name text, remark_name text, avatar_url text, sex text, location text, noble_grade_image_url text, intimacy text, intimacy_grade integer(4) default 0, intimacy_name text)
        """
    }
    
    enum NormalSQLs: String {
        
        /// 查询用户信息
        case selectUserInfo =
        """
        SELECT * FROM bp_user_info
        WHERE user_id = ?
        """
        
        /// 插入用户信息
        case insertUserInfo =
        """
        REPLACE INTO bp_user_info(user_id, real_name, remark_name, intimacy, avatar_url, sex, location, noble_grade_image_url)
        VALUES
        (?, ?, ?, ?, ?, ?, ?, ?)
        """
        
        /// 插入用户者头像
        case insertUserAvatar =
        """
        REPLACE INTO bp_user_info(user_id avatar_url)
        VALUES
        (?, ?)
        """
        
        /// 插入用户姓名
        case insertUserName =
        """
        REPLACE INTO bp_user_info(user_id, real_name)
        VALUES
        (?, ?)
        """
        
        /// 插入用户备注名
        case insertUserRemarkName =
        """
        REPLACE INTO bp_user_info(user_id, remark_name)
        VALUES
        (?, ?)
        """
        
        /// 插入用户亲密度
        case insertUserIntimacy =
        """
        REPLACE INTO bp_user_info(user_id, intimacy, intimacy_grade, intimacy_name)
        VALUES
        (?, ?, ?, ?)
        """
        
        /// 插入或覆盖
        case updateUserInfo =
        """
        UPDATE bp_user_info
        SET
        real_name = ?,
        remark_name = ?,
        intimacy = ?,
        avatar_url = ?,
        sex = ?,
        location = ?,
        noble_grade_image_url = ?
        WHERE user_id = ?
        """
        
        /// 更换用户名
        case updateUserName =
        """
        UPDATE bp_user_info
        SET
        real_name = ?
        WHERE user_id = ?
        """
        
        /// 更换用户备注名称
        case updateUserRemarkName =
        """
        UPDATE bp_user_info
        SET
        remark_name = ?
        WHERE user_id = ?
        """
        
        case updateUserAvatar =
        """
        UPDATE bp_user_info
        SET
        avatar_url = ?
        WHERE user_id = ?
        """
        
        /// 更新亲密度
        case updateIntimacy =
        """
        UPDATE bp_user_info
        SET
        intimacy = ?,
        intimacy_grade = ?,
        intimacy_name = ?
        WHERE user_id = ?
        """
    }

    
}
