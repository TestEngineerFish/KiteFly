//
//  BPChatRoomViewController.swift
//  MessageCenter
//
//  Created by apple on 2021/10/29.
//  Copyright © 2021 KLC. All rights reserved.
//

import UIKit
import RongIMLib
import IQKeyboardManager

/// 发送消息类型
public enum BPSendMessageType: Int {
    /// 文本
    case text  = 1
    /// 单张图片
    case image = 2
    /// 语音
    case audio = 3
    /// 音视频通话
    case call  = 4
    /// 礼物
    case gift  = 5
    /// 红包
    case money = 6
}


@objc(BPChatRoomViewController)
open class BPChatRoomViewController:
    BPViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    BPChatRoomToolsViewDelegate,
    BPChatRoomCellDelegate
{

    /// 好友信息
    var userModel: KFUserModel?
    
    /// 消息列表
    private var messageModelList: [RCMessage] = []
    /// 更新高度定时器（防止段时间内大量消息）
    private var updateTimer: Timer?
    /// 是否在加载中
    private var isLoading = false
    /// 是否首次加载
    private var isFirstLoad: Bool    = true
    /// 是否还有历史消息
    private var hasMoreMessage: Bool = true
    /// 一批加载消息数量
    private let batchMessageCount: Int32 = 30
    /// 当前聊天过程中，其他用户发来的未读消息总数
    private var otherChatUnreadMessageCount: Int = 0
    
    private var tableView: BPTableView = {
        let tableView = BPTableView()
        tableView.backgroundColor                = .white
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle                 = .none
        tableView.isHideEmptyView                = true
        return tableView
    }()

    private var contentView = BPView(frame: CGRect(x: 0, y: kNavHeight, width: kScreenWidth, height: kScreenHeight - kNavHeight))
    private var toolsView:BPChatRoomToolsView = {
        let view = BPChatRoomToolsView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    deinit {
        BPPlayerManager.share.stop()
        self.updateTimer?.invalidate()
        self.updateTimer = nil
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
        self.updateUI()
        self.registerNotification()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BPPlayerManager.share.stop()
        self.view.endEditing(true)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    open override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(contentView)
        contentView.addSubview(tableView)
        contentView.addSubview(toolsView)
        
        contentView.frame = CGRect(x: 0, y: kNavHeight, width: kScreenWidth, height: kScreenHeight - kNavHeight)
        tableView.frame   = CGRect(x: 0, y: 0, width: kScreenWidth, height: contentView.height - toolsView.currentHeight)
        toolsView.frame   = CGRect(x: 0, y: tableView.height, width: tableView.width, height: toolsView.currentHeight)
        
        toolsView.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(16))
        self.view.sendSubviewToBack(contentView)
    }

    open override func bindProperty() {
        super.bindProperty()
        self.tableView.delegate         = self
        self.tableView.dataSource       = self
        self.toolsView.delegate         = self
        let tapTableView = UITapGestureRecognizer(target: self, action: #selector(clickTableViewAction))
        self.tableView.addGestureRecognizer(tapTableView)
        // 注册Cell
        self.tableView.register(BPChatRoomMessageCell.classForCoder(), forCellReuseIdentifier: BPChatRoomMessageCellFactory.normalCellID)
        
        self.tableView.register(BPChatRoomMessageTextCell.classForCoder(), forCellReuseIdentifier: BPChatRoomMessageCellFactory.textCellID)
        self.tableView.register(BPChatRoomMessageAudioCell.classForCoder(), forCellReuseIdentifier: BPChatRoomMessageCellFactory.audioCellID)
        self.tableView.register(BPChatRoomMessageImageCell.classForCoder(), forCellReuseIdentifier: BPChatRoomMessageCellFactory.imageCellID)
        self.tableView.register(BPChatRoomEmptyCell.classForCoder(), forCellReuseIdentifier: BPChatRoomMessageCellFactory.emptyCellID)
        
        self.updateCustomNavigationBar()
    }

    open override func bindData() {
        super.bindData()
        // 加载消息
        self.loadMoreMessage()
        // 填充草稿
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let _draft = self.getDraft()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.toolsView.setDefaultContent(content: _draft)
            }
        }
    }
    
    open override func updateUI() {
        super.updateUI()
        self.view.backgroundColor                   = .white
    }
    
    open override func registerNotification() {
        super.registerNotification()
    }
    
    /// 更新导航栏
    private func updateCustomNavigationBar() {
        self.customNavigationBar?.title = userModel?.name
        self.customNavigationBar?.rightTitle = "详情"
    }
    
    open override func rightAction() {
        super.rightAction()
        let vc = KFSettingUserDetailViewController()
        vc.model = self.userModel
        self.navigationController?.push(vc: vc)
    }
    
    @objc
    private func playFinishedNotification(sender: Notification) {
        guard let _urlStr = sender.userInfo?["url"] as? String else {
            return
        }
        self.messageModelList.forEach { message in
            if message.objectName == RCHQVoiceMessage.getObjectName() {
                if let audioMessage = message.content as? RCHQVoiceMessage, _urlStr == audioMessage.remoteUrl {
                    audioMessage.isPlaying = false
                }
            }
        }
    }
    
    /// 进入桌面
    @objc
    private func didEnterBackground() {
        BPPlayerManager.share.stop()
    }
    
    // MARK: ==== Gesture ====
    @objc
    private func clickTableViewAction() {
        self.recover()
        self.toolsView.notificationRecover()
    }
    
    // MARK: ==== Request ====
    /// 加载更多历史消息
    @objc
    private func loadMoreMessage() {
        guard let _id = self.userModel?.id else {
            return
        }
        self.isLoading = true
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let lastMessageTime = self.messageModelList.first?.time
            let historyMessageList = BPChatRequestManager.share.requestHistoryMessaes(sessionId: _id, lastMessageId: self.messageModelList.first?.messageId, lastMessageTime: lastMessageTime, count:  self.batchMessageCount)
            self.isFirstLoad        = self.messageModelList.isEmpty
            self.hasMoreMessage     = !historyMessageList.isEmpty
            self.messageModelList   = historyMessageList + self.messageModelList
            self.reload(loadMore: true) { [weak self] in
                self?.isLoading = false
            }
        }
    }
    
    // MARK: ==== Event ====
    
    @objc
    private func reload(loadMore: Bool = false, complete block: DefaultBlock? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let oldContentHeight = self.tableView.contentSize.height
            self.tableView.reloadData()
            // 下拉分页处理
            if loadMore {
                self.tableView.layoutIfNeeded()
                let newContentHeight = self.tableView.contentSize.height
                let offsetY          = newContentHeight - oldContentHeight
                self.tableView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
            }
            block?()
        }
    }
    /// 发送撤回消息请求
    private func sendWithdrawMessage(message model: RCMessage, indexPath: IndexPath) {
//        guard let _session = self.sessionModel else { return }
//        let message = RCMessage()
//        message.messageSubType = NIMTextMessageType.withdraw.rawValue
//        if model.messageType == .text {
//            message.localExt       = ["text" : model.text ?? ""]
//        }
//        self.updateMessage(message: message, indexPath: indexPath)
//        NIMSDK.shared().conversationManager.save(message, for: _session, completion: nil)
    }

    /// 发送文本消息
    private func sendTextMessage(text: String) {
        guard text.isNotEmpty else { return }
        let content = RCTextMessage(content: text)
        self.sendMessage(content, name: RCTextMessage.getObjectName())
    }

    /// 发送图片消息
    private func sendImageMessage(image: UIImage, id: Int) {
        guard let _imageData = image.compressSize(kb: 1024), let _sessionId = self.userModel?.id else { return }
        // 本地缓存
        let imageMessage = RCImageMessage(image: image)
        let timeStr = "\(Date().timeIntervalSince1970 * 1000000)".md5()
        let imageName = "\(_sessionId)_\(id)_\(timeStr)"
        imageMessage?.localPath = imageName
        BPFileManager.share.saveSessionMedia(type: .sessionImage, name: imageName, sessionId: _sessionId, data: _imageData, userId: _sessionId)
        self.sendMediaMessage(imageMessage, data: _imageData, objectName: RCImageMessage.getObjectName())
    }
    
    func sendAudioMessage(data: Data, local path: String, duration: TimeInterval) {
        guard let _sessionId = self.userModel?.id else { return }
        let audioName  = "\(Date().timeIntervalSince1970)"
        let _localPath = BPFileManager.share.saveSessionAudio(audioData: data, sessionId: _sessionId, name: audioName, userId: "")
        let messageContext = RCHQVoiceMessage(path: path, duration: duration.second())
        messageContext.localPath = _localPath
        messageContext.name      = audioName
        messageContext.remoteUrl = path
        self.sendMediaMessage(messageContext, data: data, objectName: RCHQVoiceMessage.getObjectName())
    }

    /// 发送消息时的处理逻辑
    /// - Parameters:
    ///   - updateSession: 是否更新最近会话列表
    ///   - checkTime: 是否检测时间戳
    ///   - model: 消息对象
    private func sendMessage(_ content: RCMessageContent?, name: String? = nil) {
        guard let id = self.userModel?.id, let _content = content else { return }
        // ---- 【本地】先插入消息 ----
        guard let message = RCMessage(type: .ConversationType_PRIVATE, targetId: id, direction: .MessageDirection_SEND, content: _content) else {
            return
        }
        message.canIncludeExpansion = true
        if let _name = name {
            message.objectName = _name
        }
        message.sentStatus = .SentStatus_SENT
        self.appendMessage(message: message)
        self.insertMessaget(message: message)
        self.reload()
    }
    
    private func sendMediaMessage(_ content: RCMessageContent?, data: Data, objectName: String) {
        guard let id = self.userModel?.id, let _content = content else { return }
        // ---- 【本地】先插入消息 ----
        guard let message = RCMessage(type: .ConversationType_PRIVATE, targetId: id, direction: .MessageDirection_SEND, content: _content) else  {
            return
        }
        message.objectName = objectName
        message.canIncludeExpansion = true
        message.sentStatus = .SentStatus_SENT
        message.sentTime   = Int64(Date().timeIntervalSince1970 * 1000)
        self.appendMessage(message: message)
//        message.sentStatus = .SentStatus_FAILED
        self.insertMessaget(message: message)
        self.updateSendMessageStatus(message: message)
    }
    
    /// 添加消息（用户发送完消息后等列表更新）
    /// - Parameter message: 消息对象
    private func appendMessage(message: RCMessage) {
        // 更新是否显示时间戳状态
        message.updateShowTimeStatus(lastMessageTime: self.messageModelList.last?.time)
        DispatchQueue.main.async {
            self.tableView.performBatchUpdates {
                print("插入数据中。。。")
                let row = self.tableView.numberOfRows(inSection: 0)
                self.messageModelList.append(message)
                self.tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .none)
            } completion: { result in
                self.scrollViewToBottom(animated: false)
            }
        }
    }
    
    /// 插入消息（存储于融云数据库）
    /// - Parameter message: 消息对象
    private func insertMessaget(message: RCMessage) {
        guard let rcMessage = RCIMClient.shared().insertOutgoingMessage(.ConversationType_PRIVATE, targetId: message.targetId, sentStatus: message.sentStatus, content: message.content) else { return }
        message.messageId = rcMessage.messageId
    }
    
    /// 更新消息（撤回消息后更新）
    private func updateMessage(message: RCMessage, indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.beginUpdates()
            self.messageModelList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            if self.messageModelList.count < indexPath.row {
                self.tableView.beginUpdates()
                self.messageModelList.insert(message, at: indexPath.row)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            } else {
//                self.appendMessage(content: message.content, direction: .MessageDirection_SEND)
            }
        }
    }
    
    // MARK: ==== Tools ===
    
    /// 滑动到列表底部
    /// - Parameter animated: 是否显示动画
    private func scrollViewToBottom(animated: Bool = true) {
        if !self.messageModelList.isEmpty {
            let rows = self.tableView.numberOfRows(inSection: 0)
            guard rows > 0 else { return }
            self.tableView.scrollToRow(at: IndexPath(row: rows - 1, section: 0), at: .bottom, animated: animated)
        }
    }
    
    /// 获取图片、视频资源数组
    /// - Parameter lastMessage: 是否有最后一条消息，如果有则从最后一条开始查
    private func getMediaModelList(lastMessage: RCMessage?, complete block: (([BPMediaModel])->Void)?) {
        var mediaList: [BPMediaModel] = []
        self.messageModelList.forEach { message in
            if message.objectName == RCImageMessage.getObjectName() {
                if let imageContent = message.content as? RCImageMessage {
                    let imageModel = BPMediaImageModel()
                    imageModel.messageId        = "\(message.messageId)"
                    imageModel.originLocalPath  = imageContent.localPath
                    imageModel.image            = imageContent.originalImage
                    imageModel.originRemotePath = imageContent.imageUrl
                    mediaList.append(imageModel)
                }
            }
        }
        block?(mediaList)
    }
    
    /// 获取草稿
    /// - Returns: 保存的内容
    private func getDraft() -> String? {
        guard let _id = self.userModel?.id else {
            return nil
        }
        let _draft = RCIMClient.shared().getTextMessageDraft(.ConversationType_PRIVATE, targetId: _id)
        return _draft
    }
    
    /// 更新消息已读
    private func updateReceviceMessageRead(message: RCMessage) {
        guard let _sessionID = userModel?.id else {
            return
        }
        // 更新本地消息为已读
        RCIMClient.shared().setMessageReceivedStatus(message.messageId, receivedStatus: .ReceivedStatus_READ)
        
        // 发送回执
        RCIMClient.shared().sendReadReceiptMessage(.ConversationType_PRIVATE, targetId: _sessionID, time: message.sentTime) {
        } error: { errorCode in
            print("标志消息已读失败, errorCode:\(errorCode), message ID：\(message.messageId)")
        }
    }
    
    /// 更新消息已听
    private func updateReceiveMessageListened(message: RCMessage) {
        guard let _sessionID = userModel?.id else {
            return
        }
        // 更新本地为已听
        RCIMClient.shared().setMessageReceivedStatus(message.messageId, receivedStatus: .ReceivedStatus_LISTENED)

        // 发送回执
        RCIMClient.shared().sendReadReceiptMessage(.ConversationType_PRIVATE, targetId: _sessionID, time: message.sentTime) {
        } error: { errorCode in
            print("标志录音已听失败, errorCode:\(errorCode), message ID：\(message.messageId)")
        }
    }
    
    /// 更新消息状态
    private func updateSendMessageStatus(message: RCMessage) {
    }

    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.messageModelList.count
        if isFirstLoad {
            self.isFirstLoad = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) { [weak self] in
                guard let self = self else { return }
                self.scrollViewToBottom(animated: false)
            }
        }
        return count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageModel = self.messageModelList[indexPath.row]
        guard let cell = BPChatRoomMessageCellFactory.buildCell(tableView: tableView, message: messageModel) else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: BPChatRoomMessageCellFactory.emptyCellID) as? BPChatRoomEmptyCell {
                return cell
            } else {
                return UITableViewCell()
            }
        }
        cell.delegate = self
        cell.bindData(message: messageModel, indexPath: indexPath)
        // 高度缓存（小灰条异步更新高度缓存）
        if messageModel.bubbleHeight == nil && messageModel.objectName != RCInformationNotificationMessage.getObjectName() {
            var _cellHeight = cell.contentView.systemLayoutSizeFitting(CGSize(width: tableView.width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
            if messageModel.isShowTime {
                _cellHeight = _cellHeight - cell.timeHeight
            }
            _cellHeight -= AdaptSize(20)
            messageModel.bubbleHeight = _cellHeight
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row < self.messageModelList.count else {
            return
        }
        let messageModel = self.messageModelList[indexPath.row]
        // 接收的消息标识已读
        if messageModel.messageDirection == .MessageDirection_RECEIVE {
            // 如果未读
            if messageModel.receivedStatus == .ReceivedStatus_UNREAD
            {
                self.updateReceviceMessageRead(message: messageModel)
            }
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 收起编辑状态
        self.recover()
        self.toolsView.notificationRecover()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.messageModelList[indexPath.row]
        var cellHeight: CGFloat?
        if var bubbleHeight = model.bubbleHeight {
            bubbleHeight += AdaptSize(20)
            // 如果内容小于最低高度
            if bubbleHeight < AdaptSize(60) {
                bubbleHeight = AdaptSize(60)
            }
            cellHeight = model.isShowTime ? bubbleHeight + AdaptSize(36) : bubbleHeight
        }
        return cellHeight ?? UITableView.automaticDimension
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isTracking {
            self.recover()
            self.toolsView.notificationRecover()
        }
        if scrollView.contentOffset.y < 0 && hasMoreMessage && !self.isLoading {
            self.loadMoreMessage()
        }
    }
    
    // MARK: ==== BPChatRoomToolsViewDelegate ====
    
    func clickToolsBarAction(type: BPChatToolsItemType) {
        switch type {
        case .record:
            BPAuthorizationManager.share.authorizeMicrophoneWith { result in
                print("麦克风授权：\(result)")
            }
        case .commonWords, .textView, .more, .normal:
            break
        case .videoAndAudio:
            break
//            guard let _id = self.sessionID?.intValue else { return }
//            self.view.showLoading()
//            BPChatRequestManager.share.requestCallPrice(userId: _id) { [weak self] model in
//                guard let self = self else { return }
//                self.view.hideLoading()
//                // 音视频
//                BPCallActionSheet().showVideoAndAudio(model: model, videoBlock: {
//                    let parameters = ["userId": NSNumber(integerLiteral: self.sessionID?.intValue ?? 0), "isVideo" : NSNumber(booleanLiteral: true)]
//                    LBAppRoutes.routeName(LB_live_LaunchOneLive, currentVC: self, parameters: parameters)
//                }, audioBlock: {
//                    let parameters = ["userId": NSNumber(integerLiteral: self.sessionID?.intValue ?? 0), "isVideo" : NSNumber(booleanLiteral: false)]
//                    LBAppRoutes.routeName(LB_live_LaunchOneLive, currentVC: self, parameters: parameters)
//                })
//            }
        case .image:
            BPActionSheet().addItem(icon: UIImage(named: "chat_tools_icon_video"), title: " 拍摄照片") { [weak self] in
                guard let self = self else { return }
                BPSystemPhotoManager.share.showCamera { [weak self] (models: [BPMediaModel]) in
                    guard let self = self, let imageModel = models.last as? BPMediaImageModel, let image = imageModel.image else { return }
                    self.sendImageMessage(image: image, id: 0)
                }
            }.addItem(icon: UIImage(named: "select_camera_icon"), title: " 从手机相册选择") { [weak self] in
                guard let self = self else { return }
                BPSystemPhotoManager.share.showPhoto(complete: { [weak self] (models: [BPMediaModel]) in
                    guard let self = self else { return }
                    for (index, mediaModel) in models.enumerated() {
                        if let imageModel = mediaModel as? BPMediaImageModel {
                            if let image = imageModel.image {
                                self.sendImageMessage(image: image, id: index)
                            }
                        }
                    }
                }, maxCount: 9)
            }.show()
        case .emoji:
            break
        case .gift:
            break
        }
    }
    
    func updateToolsViewHeight() {
        self.toolsView.height = self.toolsView.currentHeight
        self.tableView.height = self.contentView.height - self.toolsView.currentHeight
        self.toolsView.top    = self.tableView.height
    }
    
    func transformOffsetY(y: CGFloat, duration: TimeInterval) {
        guard self.toolsView.transform.ty != y else { return }
        self.toolsView.height    = self.toolsView.currentHeight
        toolsView.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(16))
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.tableView.height    = self.contentView.height - self.toolsView.currentHeight
            self.toolsView.transform = CGAffineTransform(translationX: 0, y: y)
        }
        // 编辑状态默认滑动到底部
        self.scrollViewToBottom()
    }
    
    func recover(duration: TimeInterval = 0.25) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.tableView.height    = self.contentView.height - self.toolsView.currentHeight
            self.toolsView.transform = .identity
        } completion: { [weak self] result in
            guard let self = self, result else {
                return
            }
            self.toolsView.height = self.toolsView.currentHeight
            self.toolsView.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(16))
        }
    }
    
    func sendMessageAction(text: String) {
        self.sendTextMessage(text: text)
    }
    
    /// 保存到草稿
    func saveDraft(text: String) {
        guard let _id = self.userModel?.id else { return }
        RCIMClient.shared().saveTextMessageDraft(.ConversationType_PRIVATE, targetId: "\(_id)", content: text)
    }

    // MARK: ==== BPChatRoomCellDelegate ====
    func clickBubble(model: RCMessage, indexPath: IndexPath) {
        self.clickTableViewAction()
        switch model.objectName {
        case RCImageMessage.getObjectName():
            guard let cell = tableView.cellForRow(at: indexPath) as? BPChatRoomMessageImageCell else {
                return
            }
            // 获取动画起始位置
            let _imageView: BPImageView = cell.contentImageView
            self.getMediaModelList(lastMessage: nil) { mediaModelList in
                // 计算下标
                var index = mediaModelList.count - 1
                for (_index, _mediaModel) in mediaModelList.enumerated() {
                    _mediaModel.sessionId = self.userModel?.id
                    if _mediaModel.messageId == "\(model.messageId)" {
                        index = _index
                    }
                }
                BPBrowserView(type: .custom(modelList: mediaModelList), current: index).show(animationView: _imageView)
            }
        case RCHQVoiceMessage.getObjectName():
            // 更新未读状态
            if model.messageDirection == .MessageDirection_RECEIVE {
                if model.receivedStatus != .ReceivedStatus_LISTENED {
                    self.updateReceiveMessageListened(message: model)
                }
            }
        default:
            break
        }
    }

    func withdrawAction(model: RCMessage, indexPath: IndexPath) {
//        NIMSDK.shared().chatManager.revokeMessage(model) { [weak self] error in
//            guard let self = self else { return }
//            if let _error = error {
//                print("撤回消息失败：\(_error)")
//            } else {
//                self.sendWithdrawMessage(message: model, indexPath: indexPath)
//            }
//        }
    }

    func reeditAction(model: RCMessage, indexPath: IndexPath) {
//        guard let reeditText = model.localExt?["text"] as? String else {
//            return
//        }
//        self.toolsView.setDefaultContent(content: reeditText)
    }

    func clickAvatarAction(model: RCMessage, indexPath: IndexPath) {
       
    }
    
    func deleteMessageAction(model: RCMessage, indexPath: IndexPath, complete block: BoolBlock?, isReload: Bool) {
        guard RCIMClient.shared().deleteMessages([NSNumber(integerLiteral: model.messageId)]) else {
            block?(false)
            return
        }
        if indexPath.row < self.messageModelList.count {
            self.messageModelList.remove(at: indexPath.row)
        }
        if indexPath.row < self.messageModelList.count {
            // 如果下一条消息是小灰条则也删除
            let messageModel = self.messageModelList[indexPath.row]
            if messageModel.objectName == RCInformationNotificationMessage.getObjectName() {
                if RCIMClient.shared().deleteMessages([NSNumber(integerLiteral: messageModel.messageId)]) {
                    self.messageModelList.remove(at: indexPath.row)
                }
            }
        }

        block?(true)
        if isReload {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func resendMessage(model: RCMessage, indexPath: IndexPath) {
        // 暂时隐藏重发逻辑
        return;
    }

    func updateCellSize(size: CGSize, model: RCMessage, indexPath: IndexPath) {
        var updateDataTuple:[(CGSize, RCMessage, IndexPath)] = []
        updateDataTuple.append((size, model, indexPath))
        self.updateTimer = Timer(timeInterval: 0.5, repeats: false, block: { timer in
            print("==update== 更新数量:\(updateDataTuple.count)")
            updateDataTuple.forEach { tuple in
                if tuple.2.row < self.messageModelList.count {
                    let messageModel = self.messageModelList[tuple.2.row]
                    messageModel.bubbleHeight = tuple.0.height
                    messageModel.bubbleWidth  = tuple.0.width
                }
            }
            self.tableView.performBatchUpdates {
                print("更新高度中。。。")
            } completion: { result in
                if result {
                    print("更新高度结束")
                    timer.invalidate()
                }
            }
        })
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                self.updateTimer?.fire()
            }
        } else {
            self.updateTimer?.fire()
        }
        print("indexPath: \(indexPath.row), size: \(size)")
    }
}
