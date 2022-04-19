//
//  KFCommunityRemarkViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import IQKeyboardManager
import STYKit

class KFCommunityRemarkViewController: TYViewController_ty {
    
    var model: KFCommunityModel?
    
    private let textView: IQTextView = {
        let textView = IQTextView()
        textView.placeholder = "请输入您的想法"
        textView.font        = UIFont.regular_ty(AdaptSize_ty(15))
        textView.textColor   = UIColor.black0
        return textView
    }()
    
    private var submitButton: TYButton_ty = {
        let button = TYButton_ty(.theme_ty)
        button.setTitle("提交", for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(15))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.bindData_ty()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "社区主页 -- 评论详情")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(textView)
        self.view.addSubview(submitButton)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "发布评论"
        self.customNavigationBar_ty?.setRightTitle_ty(text_ty: "?")
        self.submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }
    
    override func rightAction_ty() {
        super.rightAction_ty()
        TYAlertManager_ty.share_ty.oneButton_ty(title_ty: "提示", description_ty: "发布内容必须遵守法律法规，否则将被移除，且追究法律责任。\n1、禁止发布传达、传送破坏社会的违法信息。\n2、不得侵犯他人隐私权。\n3、不得发布恶意虚构事实，欺骗他人的信息。\n4、不得涉及黄、赌、毒。\n5、不得发布政治敏感内容。\n6、禁止发布其他违法行为。", buttonName_ty: "知道了", closure_ty: nil).show_ty()
    }
    
    override func bindData_ty() {
        super.bindData_ty()
        self.view.backgroundColor = UIColor.gray0
    }
    
    override func updateViewConstraints() {
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.top.equalToSuperview().offset(kNavigationHeight_ty + AdaptSize_ty(20))
            make.height.equalTo(AdaptSize_ty(200))
        }
        submitButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(200), height: AdaptSize_ty(35)))
            make.centerX.equalToSuperview()
            make.top.equalTo(textView.snp.bottom).offset(AdaptSize_ty(20))
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    @objc
    private func submitAction() {
        guard textView.text.isNotEmpty_ty else {
            kWindow_ty.toast_ty("请输入内容")
            return
        }
        kWindow_ty.toast_ty("发布成功")
        self.navigationController?.pop_ty()
    }
}
