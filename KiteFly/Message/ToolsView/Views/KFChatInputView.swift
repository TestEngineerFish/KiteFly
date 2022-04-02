//
//  BPChatInputView.swift
//  MessageCenter
//
//  Created by apple on 2022/1/20.
//

import Foundation
import IQKeyboardManager
import UIKit

protocol KFChatInputViewDelegate: NSObjectProtocol {
    func clickItemAction(type: KFChatToolsItemType, isSelected: Bool)
    /// 发送文本消息
    func sendTextMessageAction(text: String)
    /// 发送语音消息
    func sendAudioMessageAction(data: Data, localPath: String, duration: TimeInterval)
    /// 更新草稿
    func updateDraft(text: String)
    /// 更新输入栏高度
    func updateInputHeight()
}

class KFChatInputView:
    KFView,
    UITextViewDelegate,
    KFRecordToolViewDelegate {
    
    /// 文本输入框最大高度
    private let maxTextViewHeight = AdaptSize(113)
    /// 文本输入框最小高度
    private let minTextViewHeight = AdaptSize(36)
    /// 文本框当前高度
    private var textViewHeight    = AdaptSize(36)
    
    weak var delegate: KFChatInputViewDelegate?
    
    private var recordIconButton: KFButton = {
        let button = KFButton(size: CGSize(width: AdaptSize(33), height: AdaptSize(33)))
        button.setImage(UIImage(named: "chat_record"), for: .normal)
        button.setImage(UIImage(named: "chat_keyboard"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: AdaptSize(5), left: AdaptSize(5), bottom: AdaptSize(5), right: AdaptSize(5))
        return button
    }()
    private var recordBtton: KFButton = {
        let button = KFButton()
        button.isHidden = true
        button.setTitle("按住说话", for: .normal)
        button.setTitleColor(UIColor.black0, for: .normal)
        button.titleLabel?.font = UIFont.mediumFont(ofSize: 14)
        return button
    }()
    private var textView: IQTextView = {
        let textView = IQTextView()
        textView.placeholder      = ""
        // 左右内边距
        textView.textContainer.lineFragmentPadding = .zero
        // 上下内边距
        textView.textContainerInset = UIEdgeInsets(top: AdaptSize(10), left: AdaptSize(10), bottom: AdaptSize(10), right: AdaptSize(10))
        textView.layer.cornerRadius = AdaptSize(5)
        textView.font               = UIFont.regularFont(ofSize: AdaptSize(15))
        textView.returnKeyType      = .send
        textView.enablesReturnKeyAutomatically  = true // 无文字不可点Return
        textView.showsVerticalScrollIndicator   = false
        textView.showsHorizontalScrollIndicator = false
        textView.layer.masksToBounds = true
        return textView
    }()
    
    /// 表情
    private var emojiButton: KFButton = {
        let button = KFButton(size: CGSize(width: AdaptSize(33), height: AdaptSize(33)))
        button.setImage(UIImage(named: "chat_emoji"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: AdaptSize(5), left: AdaptSize(5), bottom: AdaptSize(5), right: AdaptSize(5))
        return button
    }()
    
    /// 更多
    private var moreButton: KFButton = {
        let button = KFButton(size: CGSize(width: AdaptSize(33), height: AdaptSize(33)))
//        button.setImage(UIImage(named: "chat_tools_more_unselect"), for: .normal)
//        button.setImage(UIImage(named: "chat_tools_more_selected"), for: .selected)
        button.setImage(UIImage(named: "chat_image"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: AdaptSize(5), left: AdaptSize(5), bottom: AdaptSize(5), right: AdaptSize(5))
        return button
    }()
    
    /// 录入语音页面
    private var recordToolView: KFRecordToolView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    deinit {
        IQKeyboardManager.shared().isEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(recordIconButton)
        self.addSubview(textView)
        self.addSubview(recordBtton)
        self.addSubview(emojiButton)
        self.addSubview(moreButton)
        
        recordIconButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(10))
            make.size.equalTo(recordIconButton.size)
            make.bottom.equalToSuperview().offset(AdaptSize(-16))
        }
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(recordIconButton.snp.right).offset(AdaptSize(9))
            make.right.equalTo(moreButton.snp.left).offset(AdaptSize(-9))
            make.top.equalToSuperview().offset(AdaptSize(7))
            make.height.equalTo(textViewHeight)
        }
        recordBtton.snp.makeConstraints { make in
            make.left.right.top.equalTo(textView)
            make.height.equalTo(minTextViewHeight)
        }
        moreButton.snp.makeConstraints { make in
            make.right.equalTo(emojiButton.snp.left).offset(AdaptSize(-1))
            make.size.equalTo(moreButton.size)
            make.centerY.equalTo(recordIconButton)
        }
        emojiButton.snp.makeConstraints { make in
            make.size.equalTo(emojiButton.size)
            make.right.equalToSuperview().offset(AdaptSize(-9))
            make.centerY.equalTo(recordIconButton)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.textView.delegate = self
        self.recordIconButton.addTarget(self, action: #selector(clickRecordIconButton(sender:)), for: .touchUpInside)
        self.emojiButton.addTarget(self, action: #selector(emojiAction(sender:)), for: .touchUpInside)
        self.moreButton.addTarget(self, action: #selector(moreAction(sender:)), for: .touchUpInside)
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(panAction(sender:)))
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecordAction(sender:)))
        self.recordBtton.addGestureRecognizer(longPressGes)
        self.recordBtton.addGestureRecognizer(panGes)
        self.textView.layer.cornerRadius     = minTextViewHeight/2
        self.recordBtton.layer.cornerRadius  = minTextViewHeight/2
        self.textView.layer.masksToBounds    = true
        self.recordBtton.layer.masksToBounds = true
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func updateUI() {
        super.updateUI()
        self.recordBtton.backgroundColor  = UIColor.gray0
        self.textView.backgroundColor     = UIColor.gray0
        self.textView.textColor           = UIColor.black0
    }
    
    override func registerNotification() {
        super.registerNotification()
        self.textView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    // MARK: ==== Event ====
    
    /// 文本框是否处于编辑状态
    func textViewFirstResponder() -> Bool {
        return self.textView.isFirstResponder
    }
    
    /// 取消编辑状态
    func endEdit() {
        if self.textView.isFirstResponder {
            self.textView.resignFirstResponder()
        }
    }
    
    /// 更新更多功能按钮的选中状态
    /// - Parameter isSelected: 是否选中 
    func updateMoreStatus(isSelected: Bool) {
        self.moreButton.isSelected = isSelected
    }
    
    /// 获取高度
    func getCurrentHeight() -> CGFloat {
        // 是否在录音状态中
        if self.recordIconButton.isSelected {
            return minTextViewHeight + AdaptSize(20)
        } else {
            return textViewHeight + AdaptSize(20)
        }
    }
    
    func updateHeight() {
        self.textView.snp.updateConstraints { [weak self] make in
            guard let self = self else { return }
            if self.recordIconButton.isSelected {
                make.height.equalTo(self.minTextViewHeight)
            } else {
                make.height.equalTo(self.textViewHeight)
            }
        }
    }
    
    func setDraft(text: String?) {
        let font  = UIFont.regularFont(ofSize: AdaptSize(15))
        let color = UIColor.black0
        self.textView.attributedText = text?.convertToCommonEmations(font: font, color: color)
    }
    
    func getCurrentText() -> String {
        let _content = textView.attributedText.string
        let _attr    = textView.attributedText
        var _message = ""
        _attr?.enumerateAttributes(in: NSMakeRange(0, textView.text.count), options: .longestEffectiveRangeNotRequired, using: { (dict:[NSAttributedString.Key : Any], range: NSRange, point: UnsafeMutablePointer<ObjCBool>) in
            let _subAttr = dict[.attachment]
            if let textAttr = _subAttr as? NSTextAttachment {
                // 表情
                _message += textAttr.name ?? ""
            } else {
                let value = _content.substring(fromIndex: range.location, length: range.length)
                _message += value
            }
        })
        return _message
    }
    
    func inputText(text: String) {
        let _font   = UIFont.regularFont(ofSize: AdaptSize(15))
        let _color  = UIColor.black0
        let _mAttar = NSMutableAttributedString(attributedString:textView.attributedText)
        let _attr   = text.convertToCommonEmations(font: _font, color: _color)
        
        if let _range = textView.selectedTextRange {
            if _range.isEmpty {
                // 插入
                let _index = textView.offset(from: textView.beginningOfDocument, to: _range.start)
                _mAttar.insert(_attr, at: _index)
                self.textView.attributedText = _mAttar
                self.textView.setPosition(offset: _index + 1)
            } else {
                // 替换
                let _mAttar = NSMutableAttributedString(attributedString: self.textView.attributedText)
                _mAttar.replaceCharacters(in: textView.selectedRange, with: _attr)
                self.textView.attributedText = _mAttar
            }
        } else {
            // 添加
            _mAttar.append(_attr)
            self.textView.attributedText = _mAttar
        }
        // 如果光标在最后一行，则滑动关到底部显示
        if self.textView.getPosition() >= self.textView.attributedText.string.count - 1 {
            self.textView.scrollRangeToVisible(NSMakeRange(self.textView.getPosition(), 0))
        }
    }
    
    func deleteEmojiAction() {
        // 获得光标位置
        let index = self.textView.getPosition()
        guard let textRange = self.textView.transformRange(range: NSMakeRange(index - 1, 1)) else { return }
        self.textView.replace(textRange, withText: "")
    }
    
    // TODO: ==== Target ====
    
    ///  编辑、录音切换
    @objc
    private func clickRecordIconButton(sender: KFButton) {
        sender.isSelected = !sender.isSelected
        // 切换录音状态
        if sender.isSelected {
            self.recordBtton.isHidden   = false
            self.textView.isHidden      = true
            self.emojiButton.isSelected = false
            self.moreButton.isSelected  = false
        } else {
            self.recordBtton.isHidden = true
            self.textView.isHidden    = false
            // 是否有内容需要编辑
            self.textView.becomeFirstResponder()
        }
        self.delegate?.clickItemAction(type: .record, isSelected: sender.isSelected)
    }
    
    /// 表情
    @objc
    private func emojiAction(sender: KFButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.recordBtton.isHidden   = true
            self.textView.isHidden      = false
            self.recordBtton.isSelected = false
            self.moreButton.isSelected  = false
        }
        self.delegate?.clickItemAction(type: .emoji, isSelected: sender.isSelected)
    }
    
    @objc
    private func moreAction(sender: KFButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.recordBtton.isSelected = false
            self.emojiButton.isSelected = false
        }
        self.delegate?.clickItemAction(type: .image, isSelected: sender.isSelected)
    }
    
    @objc
    private func panAction(sender: UIPanGestureRecognizer) {
        if self.recordToolView == nil {
            self.recordToolView = KFRecordToolView()
            self.recordToolView?.delegate = self
        }
        self.recordToolView?.panAction(sender: sender)
    }
    
    @objc
    private func longPressRecordAction(sender: UILongPressGestureRecognizer) {
        if self.recordToolView == nil {
            self.recordToolView = KFRecordToolView()
            self.recordToolView?.delegate = self
        }
        self.recordToolView?.panAction(sender: sender)
    }
    
    // MARK: ==== UITextViewDelegate ====
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.delegate?.clickItemAction(type: .textView, isSelected: true)
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // 发送
            let message = self.getCurrentText()
            self.delegate?.sendTextMessageAction(text: message)
            self.textView.text = ""
            return false
        } else if text == "" {
            // 删除
            return true
        } else {
            // 更新字体和颜色
            textView.textColor = UIColor.black0
            textView.font = UIFont.regularFont(ofSize: AdaptSize(15))
            return true
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let text = self.getCurrentText()
        self.delegate?.updateDraft(text: text)
    }
    
    // MARK: ==== BPRecordToolViewDelegate ====
    func sendAudioMessage(data: Data, local path: String, duration: TimeInterval) {
        self.delegate?.sendAudioMessageAction(data: data, localPath: path, duration: duration)
        self.recordToolView = nil
    }
    
    func cancelAudioMessage() {
        self.recordToolView = nil
    }
    
    // MARK: ==== KVO ====
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // ---- 文本高度逻辑 -----
        if keyPath == "contentSize" {
            var _height = self.textView.sizeThatFits(CGSize(width: textView.width, height: maxTextViewHeight)).height
            // 高度容错（与设计的误差）
            if _height < self.minTextViewHeight * 1.5 {
                _height = minTextViewHeight
            }
            
            // 高度限制
            if _height < minTextViewHeight {
                _height = minTextViewHeight
            } else if _height > maxTextViewHeight {
                _height = maxTextViewHeight
            }
            self.textViewHeight = _height
            // 更新文本框高度
            self.textView.snp.updateConstraints { make in
                make.height.equalTo(_height)
            }
            // 通知更新
            self.delegate?.updateInputHeight()
        }
    }
    
}

