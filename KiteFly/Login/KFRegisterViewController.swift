//
//  KFRegisterViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation
import STYKit

class KFRegisterViewController: TYViewController_ty {
    
    private let accountTextField: TYTextField_ty = {
        let textField = TYTextField_ty(type_ty: .normal_ty)
        textField.placeholder = "请输入账号"
        textField.font        = UIFont.regular_ty(AdaptSize_ty(16))
        textField.textColor   = UIColor.black0
        textField.showBorder_ty  = true
        textField.showLeftView_ty = true
        textField.clearButtonMode = .whileEditing
        textField.maxCount_ty = 11
        return textField
    }()
    private let passwordTextField: TYTextField_ty = {
        let textField = TYTextField_ty(type_ty: .normal_ty)
        textField.placeholder = "请输入密码"
        textField.font        = UIFont.regular_ty(AdaptSize_ty(16))
        textField.textColor   = UIColor.black0
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.showBorder_ty  = true
        textField.showLeftView_ty = true
        textField.clearButtonMode = .whileEditing
        textField.maxCount_ty = 8
        return textField
    }()
    private let confirmTextField: TYTextField_ty = {
        let textField = TYTextField_ty(type_ty: .normal_ty)
        textField.placeholder = "请再次输入密码"
        textField.font        = UIFont.regular_ty(AdaptSize_ty(16))
        textField.textColor   = UIColor.black0
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.showBorder_ty  = true
        textField.showLeftView_ty = true
        textField.clearButtonMode = .whileEditing
        textField.maxCount_ty = 8
        return textField
    }()
    
    private var registerButton: TYButton_ty = {
        let button = TYButton_ty(.theme_ty)
        button.setTitle("注册", for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(16))
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
        KFChatRequestManager.share.requestRecord(content: "注册页面")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(accountTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(confirmTextField)
        self.view.addSubview(registerButton)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "注册"
        self.customNavigationBar_ty?.leftButton_ty.isHidden = true
        self.registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
    }
    
    override func bindData_ty() {
        super.bindData_ty()
    }
    
    override func updateViewConstraints() {
        accountTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(250), height: AdaptSize_ty(44)))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight_ty + AdaptSize_ty(100))
        }
        passwordTextField.snp.makeConstraints { make in
            make.size.centerX.equalTo(accountTextField)
            make.top.equalTo(accountTextField.snp.bottom).offset(AdaptSize_ty(20))
        }
        confirmTextField.snp.makeConstraints { make in
            make.size.centerX.equalTo(accountTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(AdaptSize_ty(20))
        }
        registerButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(150), height: AdaptSize_ty(40)))
            make.centerX.equalToSuperview()
            make.top.equalTo(confirmTextField.snp.bottom).offset(AdaptSize_ty(40))
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    @objc
    private func registerAction() {
        guard let account = accountTextField.text, let password0 = passwordTextField.text, let password1 = confirmTextField.text, account.isNotEmpty_ty, password0.isNotEmpty_ty, password1.isNotEmpty_ty else {
            kWindow_ty.toast_ty("账号密码不能为空")
            return
        }
        guard password0 == password1 else {
            kWindow_ty.toast_ty("密码不一致")
            return
        }
        kWindow_ty.showLoading_ty()
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            kWindow_ty.hideLoading_ty()
            TYAlertManager_ty.share_ty.oneButton_ty(title_ty: "提示", description_ty: "账号已存在，请直接登录", buttonName_ty: "知道了") {
                self.dismiss(animated: true)
            }.show_ty()
        }
    }
    
}
