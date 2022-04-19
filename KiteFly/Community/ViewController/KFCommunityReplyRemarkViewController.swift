//
//  KFCommunityReplyRemarkViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import IQKeyboardManager
import STYKit

class KFCommunityReplyRemarkViewController: TYViewController_ty {
    
    var model: KFCommunityRemarkModel?
    
    private let textView: IQTextView = {
        let textView = IQTextView()
        textView.placeholder = "回复评论"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "社区主页 -- 举报评论页面")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(textView)
        self.view.addSubview(submitButton)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "发布评论"
        self.submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        if let _name = self.model?.byUser?.name {
            self.textView.placeholder = "回复\(_name)的评论"
        }
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
        kWindow_ty.toast_ty("回复成功，审核通过后可展示～")
        self.dismiss(animated: true)
    }
}
