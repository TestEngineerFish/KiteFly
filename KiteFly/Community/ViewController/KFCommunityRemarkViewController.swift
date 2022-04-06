//
//  KFCommunityRemarkViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import IQKeyboardManager

class KFCommunityRemarkViewController: KFViewController {
    
    var model: KFCommunityModel?
    
    private let textView: IQTextView = {
        let textView = IQTextView()
        textView.placeholder = "请输入您的想法"
        textView.font        = UIFont.regularFont(ofSize: AdaptSize(15))
        textView.textColor   = UIColor.black0
        return textView
    }()
    
    private var submitButton: KFButton = {
        let button = KFButton(.theme)
        button.setTitle("提交", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(15))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "社区主页 -- 评论详情")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(textView)
        self.view.addSubview(submitButton)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "发布评论"
        self.customNavigationBar?.rightTitle = "?"
        self.submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }
    
    override func rightAction() {
        super.rightAction()
        KFAlertManager.share.oneButton(title: "提示", description: "发布内容必须遵守法律法规，否则将被移除，且追究法律责任。\n1、禁止发布传达、传送破坏社会的违法信息。\n2、不得侵犯他人隐私权。\n3、不得发布恶意虚构事实，欺骗他人的信息。\n4、不得涉及黄、赌、毒。\n5、不得发布政治敏感内容。\n6、禁止发布其他违法行为。", buttonName: "知道了", closure: nil).show()
    }
    
    override func bindData() {
        super.bindData()
        self.view.backgroundColor = UIColor.gray0
    }
    
    override func updateViewConstraints() {
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalToSuperview().offset(kNavHeight + AdaptSize(20))
            make.height.equalTo(AdaptSize(200))
        }
        submitButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(200), height: AdaptSize(35)))
            make.centerX.equalToSuperview()
            make.top.equalTo(textView.snp.bottom).offset(AdaptSize(20))
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    @objc
    private func submitAction() {
        guard textView.text.isNotEmpty else {
            kWindow.toast("请输入内容")
            return
        }
        kWindow.toast("发布成功")
        self.navigationController?.pop()
    }
}
