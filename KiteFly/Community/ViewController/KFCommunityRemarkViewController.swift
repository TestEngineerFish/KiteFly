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
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(textView)
        self.view.addSubview(submitButton)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "发布评论"
        self.submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
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
