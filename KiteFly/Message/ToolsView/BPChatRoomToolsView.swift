//
//  BPChatRoomToolsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit
import STYKit

enum KFChatToolsItemType: Int {
    /// 空
    case normal
    /// 录音
    case record
    /// 输入框
    case textView
    /// 表情
    case emoji
    /// 更多
    case more
    /// 常用语
    case commonWords
    /// 音视频
    case videoAndAudio
    /// 图片
    case image
    /// 礼物
    case gift
}

protocol BPChatRoomToolsViewDelegate: NSObjectProtocol {
    /// 点击事件
    func clickToolsBarAction(type: KFChatToolsItemType)
    /// 开始位移
    func transformOffsetY(y: CGFloat, duration: TimeInterval)
    /// 还原位移
    func recover(duration: TimeInterval)
    /// 更新高度
    func updateToolsViewHeight()
    /// 发送消息

    func sendMessageAction(text: String)
    /// 发送语音
    func sendAudioMessage(data: Data, local path: String, duration: TimeInterval)
    /// 存入草稿
    func saveDraft(text: String)
}

/// 工具栏视图
class BPChatRoomToolsView:
    TYView_ty,
    KFChatInputViewDelegate,
    KFChatMoreViewDelegate,
    KFEmojiToolViewDelegate
    {
 
    /// 当前总高度（返回最大高度）
    var currentHeight: CGFloat = .zero

    /// 输入栏高度
    private var inputBarHeight: CGFloat {
        self.inputBarView.getCurrentHeight()
    }
    /// 软键盘高度
    private var keyboardHeight   = AdaptSize_ty(0)
    /// 软键盘弹起收起的时常
    private var keyboardDuration = TimeInterval(0.25)
    /// 工具栏高度
    private let moreViewHeight   = AdaptSize_ty(76)
    /// Emoji表情列表高度
    private let emojiViewHeight  = AdaptSize_ty(300)
    /// 常用语高度
    private let commonViewHeight = AdaptSize_ty(244)
    /// 回调协议
    weak var delegate: BPChatRoomToolsViewDelegate?
    
    /// 当前选中的Item
    private var currentItemType: KFChatToolsItemType = .normal {
        willSet {
            var isRecover = true
            var offsetY   = CGFloat.zero
            var duration  = TimeInterval(0.25)
            switch newValue {
            case .textView:
                offsetY   = -(self.keyboardHeight - kSafeBottomMargin_ty)
                isRecover = false
                duration  = self.keyboardDuration
                self.hideMoreView()
            case .emoji:
                offsetY   = -self.emojiViewHeight
                isRecover = false
                self.moreView.hide()
                self.emojiView.show()
                self.inputBarView.updateMoreStatus(isSelected: false)
            case .more:
                offsetY   = -self.moreViewHeight
                isRecover = false
                self.moreView.show()
                self.emojiView.hide()
            case .commonWords:
                offsetY   = -self.commonViewHeight
                isRecover = false
                self.moreView.hide()
                self.emojiView.hide()
                self.inputBarView.updateMoreStatus(isSelected: false)
            case .record:
                duration  = self.keyboardDuration
            default:
                break
            }
            
            if newValue != .textView {
                self.inputBarView.endEdit()
            }
            self.currentHeight = -offsetY + self.inputBarHeight + kSafeBottomMargin_ty
            if isRecover {
                self.delegate?.recover(duration: duration)
                self.hideMoreView()
            } else {
                self.delegate?.transformOffsetY(y: offsetY, duration: duration)
            }
        }
    }
    
    /// 输入栏页面
    private var inputBarView = KFChatInputView()
    /// 更多功能页面
    private var moreView     = KFChatMoreView()
    
    /// 表情
    private var emojiView: KFEmojiToolView = {
        let view = KFEmojiToolView()
        view.hide()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.registerNotification_ty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(inputBarView)
        self.addSubview(moreView)
        self.addSubview(emojiView)
        
        inputBarView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(inputBarHeight)
        }
        moreView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(inputBarView.snp.bottom)
            make.height.equalTo(AdaptSize_ty(76))
        }
        emojiView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(moreView)
            make.height.equalTo(emojiViewHeight)
        }
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.inputBarView.delegate    = self
        self.moreView.delegate        = self
        self.emojiView.delegate       = self
        self.hideMoreView()
        self.currentItemType = .normal
    }
    
    override func registerNotification_ty() {
    }

    // MARK: ==== Event ====
    
    /// 设置默认内容（草稿、撤回重新编辑等）
    func setDefaultContent(content: String?) {
        self.inputBarView.setDraft(text: content)
        self.delegate?.updateToolsViewHeight()
    }
    
    /// 尝试收起【仅提供给外部调用，用于通知页面收起逻辑】
    func notificationRecover() {
        if self.currentItemType != .record {
            self.currentItemType = .normal
        }
    }
    
    /// 隐藏底部更多功能/Emoji表情页面
    private func hideMoreView() {
        self.moreView.hide()
        self.emojiView.hide()
        self.inputBarView.updateMoreStatus(isSelected: false)
    }
    
    /// 获取文本框中的内容
    private func getMessage() -> String {
        return self.inputBarView.getCurrentText()
    }

    // MARK: ==== Notification ====
    @objc private func showKeyboard(notification: Notification) {
        guard let frameValue = notification.userInfo?[BPChatRoomToolsView.keyboardFrameEndUserInfoKey] as? CGRect, let durationTime = notification.userInfo?[BPChatRoomToolsView.keyboardAnimationDurationUserInfoKey] as? TimeInterval, self.inputBarView.textViewFirstResponder() else {
            return
        }
        self.keyboardHeight   = frameValue.height
        self.keyboardDuration = durationTime
        self.currentItemType  = .textView
    }

    @objc private func hideKeyboard(notification: Notification) {
        guard let durationTime = notification.userInfo?[BPChatRoomToolsView.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        self.keyboardDuration = durationTime
    }
    
    // MARK: ==== BPChatInputViewDelegate ====
    func clickItemAction(type: KFChatToolsItemType, isSelected: Bool) {
        if isSelected {
            self.currentItemType = type
        } else {
            if type == .record {
                self.currentItemType = .textView
            } else {
                self.currentItemType = .normal
            }
        }
        self.delegate?.clickToolsBarAction(type: type)
    }
    
    func sendTextMessageAction(text: String) {
        self.delegate?.sendMessageAction(text: text)
        self.delegate?.saveDraft(text: "")
    }
    
    func sendAudioMessageAction(data: Data, localPath: String, duration: TimeInterval) {
        self.delegate?.sendAudioMessage(data: data, local: localPath, duration: duration)
    }
    
    func updateDraft(text: String) {
        self.delegate?.saveDraft(text: text)
    }
    
    func updateInputHeight() {
        self.delegate?.updateToolsViewHeight()
    }
    
    // MARK: ==== BPChatMoreViewDelegate ====
    func clickCommonWordsItemAction() {
        self.currentItemType = .commonWords
    }
    
    func clickVideoItemAction() {
        self.currentItemType = .videoAndAudio
        self.delegate?.clickToolsBarAction(type: .videoAndAudio)
    }
    
    func clickImageItemAction() {
        self.currentItemType = .image
        self.delegate?.clickToolsBarAction(type: .image)
    }
    
    func clickGiftItemAction() {
        self.currentItemType = .gift
        self.delegate?.clickToolsBarAction(type: .gift)
    }
    
    // MARK: ==== BPEmojiToolViewDelegate ====
    func selectedEmoji(model: KFEmojiModel) {
        guard let emojiStr = model.name else { return }
        self.inputBarView.inputText(text: emojiStr)
        // 保存草稿
        let text = self.getMessage()
        self.delegate?.saveDraft(text: text)
    }
    
    func deleteActionWithEmoji() {
        self.inputBarView.deleteEmojiAction()
    }
    
    func sendActionWithEmoji() {
        let message = self.getMessage()
        self.delegate?.sendMessageAction(text: message)
        self.inputBarView.setDraft(text: nil)
        self.delegate?.saveDraft(text: "")
    }
}
