//
//  KFMapAddViewController.swift
//  KiteFly
//
//  Created by apple on 2022/4/19.
//

import Foundation
import STYKit
import IQKeyboardManager

class KFMapAddViewController: TYViewController_ty {
    
    var id: String?
    
    var editBlock: ((String)->Void)?
    
    private let textView: IQTextView = {
        let textView = IQTextView()
        textView.placeholder = "请输入足迹信息"
        textView.font        = UIFont.regular_ty(AdaptSize_ty(15))
        textView.textColor   = UIColor.black0
        return textView
    }()
    
    private var submitButton: TYButton_ty = {
        let button = TYButton_ty(.theme_ty)
        button.setTitle("添加", for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(15))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.bindData_ty()
        self.updateUI_ty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "足迹 -- 添加足迹页面")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(textView)
        self.view.addSubview(submitButton)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "添加足迹"
        self.submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }
    
    override func bindData_ty() {
        super.bindData_ty()
    }
    
    override func updateUI_ty() {
        super.updateUI_ty()
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
        self.editBlock?(textView.text)
        kWindow_ty.showLoading_ty()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            kWindow_ty.hideLoading_ty()
            kWindow_ty.toast_ty("添加成功")
            self.dismiss(animated: true)
        }
    }
    
}
