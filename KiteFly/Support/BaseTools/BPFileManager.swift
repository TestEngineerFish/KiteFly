//
//  BPFileManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

public struct BPFileManager {
    
    public static let share = BPFileManager()
    
    /// 保存资源文件
    /// - Parameters:
    ///   - name: 文件名称
    ///   - data: 资源数据
    /// - Returns: 是否保存成功
    @discardableResult
    public func saveFile(name: String, data: Data) -> Bool {
        let path = "\(normalPath())/\(name)"
        self.checkFile(path: path)
        guard let fileHandle = FileHandle(forWritingAtPath: path) else {
            print("文件\(name)写入失败:\(path)")
            return false
        }
        fileHandle.write(data)
        return true
    }
    
    // TODO: ==== 用户头像缓存(公用) ====
    
    /// 保存头像文件
    /// - Parameters:
    ///   - urlStr: 头像网络地址
    ///   - userId: 用户ID
    ///   - data: 头像对象
    /// - Returns: 是否保存成功
    @discardableResult
    public func saveAvatar(urlStr: String, userId: String, data: Data) -> Bool {
        let dirPath  = "\(avatarPath(userId: userId))/"
        self.deleteDirectory(path: dirPath)
        let urlHash  = urlStr.md5()
        let filePath = "\(avatarPath(userId: userId))/\(urlHash)"
        self.checkFile(path: filePath)
        guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
            print("文件\(userId)写入失败:\(filePath)")
            return false
        }
        fileHandle.write(data)
        return true
    }
    
    /// 头像资源多用户共用
    /// - Parameters:
    ///   - urlStr: 头像网络地址
    ///   - userId: 用户ID
    /// - Returns: 头像本地文件
    public func receiveAvatar(urlStr: String, userId: String) -> Data? {
        let urlHash  = urlStr.md5()
        let filePath = "\(avatarPath(userId: userId))/\(urlHash)"
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: filePath) else {
            print("头像地址不存在,地址：\(filePath)， url:\(urlStr)")
            return nil
        }
        guard let fileHandle = FileHandle(forReadingAtPath: filePath) else {
            return nil
        }
        let data = fileHandle.readDataToEndOfFile()
        return data
    }
    
    // TODO: ==== 聊天图片缓存(私用) ====
    
    /// 缓存聊天室内的多媒体资源
    /// - Parameters:
    ///   - type: 资源类型
    ///   - name: 资源名称（唯一标识符即可）
    ///   - sessionId: 聊天室ID
    ///   - data: 多媒体数据
    /// - Returns: 保存路径
    @discardableResult
    public func saveSessionMedia(type: BPFileType, name: String, sessionId: String, data: Data, userId: String) -> String? {
        let filePath = self.getFilePath(type: type, name: name, sessionId: sessionId, userId: userId)
        guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
            return nil
        }
        fileHandle.write(data)
        return filePath
    }
    
    /// 获取聊天室内缓存的多媒体资源
    /// - Parameters:
    ///   - type: 资源类型
    ///   - name: 资源名称（唯一标识符即可）
    ///   - sessionId: 聊天室ID
    /// - Returns: 多媒体资源对象
    public func getSessionMedia(type: BPFileType, name: String, sessionId: String, userId: String) -> Data? {
        let filePath = self.getFilePath(type: type, name: name, sessionId: sessionId, userId: userId)
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: filePath) else {
            return nil
        }
        guard let fileHandle = FileHandle(forReadingAtPath: filePath) else {
            return nil
        }
        let data = fileHandle.readDataToEndOfFile()
        return data
    }
    
    
    /// 删除会话中的某个资源
    /// - Parameters:
    ///   - type: 资源类型
    ///   - name: 资源名称
    ///   - sessionId: 会话ID
    /// - Returns: 是否删除成功
    @discardableResult
    public func deleteSessionMedia(type: BPFileType, name: String, sessionId: String, userId: String) -> Bool {
        let filePath = self.getFilePath(type: type, name: name, sessionId: sessionId, userId: userId)
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: filePath) else {
            print("==文件== 删除文件失败:\(filePath)")
            return true
        }
        let result = self.deleteFile(path: filePath)
        if result {
            print("==文件== 删除文件成功:\(filePath)")
        } else {
            print("==文件== 删除文件失败:\(filePath)")
        }
        return result
    }
    
    /// 删除会话中所有资源
    /// - Parameter sessionId: 会话ID
    /// - Returns: 是否删除成功
    @discardableResult
    public func deleteSessionAllMedias(sessionId: String, userId: String) -> Bool {
        let _sessionPath = self.getSessionPath(sessionId: sessionId, userId: userId)
        return self.deleteDirectory(path: _sessionPath)
    }
 
    // TODO: ==== 聊天语音缓存 ====
    
    /// 缓存聊天室语音
    /// - Parameters:
    ///   - imageData: 语音
    ///   - sessionId: 聊天室ID
    ///   - name: 语音名称
    /// - Returns: 本地地址
    @discardableResult
    public func saveSessionAudio(audioData: Data, sessionId: String, name: String, userId: String) -> String? {
        let filePath = "\(sessionAudioPath(sessionId: sessionId, userId: userId))/\(name).aac"
        self.checkFile(path: filePath)
        guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
            print("文件\(name)写入失败:\(filePath)")
            return nil
        }
        fileHandle.write(audioData)
        return filePath
    }
    
    /// 获取聊天室本地缓存语音
    /// - Parameters:
    ///   - sessionId: 聊天室ID
    ///   - name: 语音名称
    /// - Returns: 图片
    public func receiveSessionAudio(sessionId: String, name: String, userId: String) -> Data? {
        let filePath = "\(sessionAudioPath(sessionId: sessionId, userId: userId))/\(name).aac"
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: filePath) else {
            return nil
        }
        guard let fileHandle = FileHandle(forReadingAtPath: filePath) else {
            return nil
        }
        let data = fileHandle.readDataToEndOfFile()
        return data
    }
    
    // TODO: ==== Tools ====
    
    public enum BPFileType: String {
        case sessionImage = "Image"
        case sessionAudio = "Audio"
    }
    
    /// 录制的音频文件路径
    public var voicePath: String {
        let path = documentPath() + "/Voice"
        self.checkDirectory(path: path)
        return path
    }

    /// 默认资源存放路径
    /// - Returns: 路径地址
    private func normalPath() -> String {
        let path = documentPath() + "/Normal"
        self.checkDirectory(path: path)
        return path
    }
    
    /// 头像资源存放路径
    /// - Returns: 路径地址
    private func avatarPath(userId: String) -> String {
        let path = documentPath() + "/Avatar/\(userId)"
        self.checkDirectory(path: path)
        return path
    }
    
    /// 聊天室中图片存储路径
    /// - Parameter sessionId: 会话ID
    /// - Returns: 路径地址
    private func sessionImagePath(sessionId: String, userId: String) -> String {
        let path = documentPath() + "/Chat_\(userId)/Images/\(sessionId)"
        self.checkDirectory(path: path)
        return path
    }
    
    /// 聊天室中语音存储路径
    /// - Parameter sessionId: 会话ID
    /// - Returns: 路径地址
    private func sessionAudioPath(sessionId: String, userId: String) -> String {
        let path = documentPath() + "/\(userId)/Audios/\(sessionId)"
        self.checkDirectory(path: path)
        return path
    }
    
    /// 云盘文件(夹)路径
    public func cloudPath(folderName:String, fileName:String? = nil) -> String {
        var path = documentPath() + "/cloud/\(folderName)"
        if let fileName = fileName{
            path.append("/\(fileName)")
        }
        return path
    }
    
    /// 文档路径
    /// - Returns: 路径地址
    func documentPath() -> String {
        var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        if documentPath == "" {
            documentPath = NSHomeDirectory() + "/Documents"
            self.checkDirectory(path: documentPath)
            return documentPath
        }
        return documentPath
    }

    /// 检查文件夹是否存在，不存在则创建
    /// - Parameter path: 文件路径
    func checkDirectory(path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("==文件==创建目录:\(path),失败：\(error)")
            }
        }
    }

    /// 检查文件是否存在，不存在则创建
    /// - Parameter path: 文件路径
    func checkFile(path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            let result = FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            if result {
                print("==文件==创建文件成功：\(path)")
            } else {
                print("==文件==创建文件失败：\(path)")
            }
        }
    }
    
    /// 删除文件夹
    /// - Parameter path: 路径
    @discardableResult
    func deleteDirectory(path: String) -> Bool {
        var result = false
        if FileManager.default.fileExists(atPath: path) {
            let manager = FileManager.default
            result  = manager.isDeletableFile(atPath: path)
            if result {
                do {
                    try manager.removeItem(atPath: path)
                    print("==文件==删除本地文件夹成功")
                } catch let error {
                    print("==文件==删除本地文件夹失败：\(error)")
                }
            }
        }
        return result
    }
    
    /// 删除文件
    /// - Parameter path: 文件路径
    /// - Returns: 是否删除成功
    func deleteFile(path: String) -> Bool {
        if FileManager.default.fileExists(atPath: path) {
            let manager = FileManager.default
            let result  = manager.isDeletableFile(atPath: path)
            if result {
                do {
                    try manager.removeItem(atPath: path)
                    return true
                } catch let error {
                    print("删除本地文件失败：\(error)")
                    return false
                }
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    /// 获取会话资源地址
    /// - Parameters:
    ///   - type: 资源类型
    ///   - name: 资源名称
    ///   - sessionId: 会话ID
    /// - Returns: 资源地址
    private func getFilePath(type: BPFileType, name: String, sessionId: String, userId: String) -> String {
        let _sessionPath  = self.getSessionPath(sessionId: sessionId, userId: userId)
        let directoryPath = _sessionPath + "/\(type.rawValue)"
        self.checkDirectory(path: directoryPath)
        let nameHash = name.md5()
        let filePath = directoryPath + "/\(nameHash)"
        self.checkFile(path: filePath)
        return filePath
    }
    
    /// 获取会话缓存地址
    /// - Parameters:
    ///   - sessionId: 会话ID
    /// - Returns: 会话缓存目录
    private func getSessionPath(sessionId: String, userId: String) -> String {
        let sessionPath = documentPath() + "/Chat_\(userId)/\(sessionId)"
        self.checkDirectory(path: sessionPath)
        return sessionPath
    }
}
