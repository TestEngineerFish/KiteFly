//
//  KFLoginViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation
import STYKit


class KFLoginViewController: TYViewController_ty {
    
    private var logoImageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = AdaptSize_ty(10)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
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
        textField.isSecureTextEntry = true
        textField.showBorder_ty  = true
        textField.showLeftView_ty = true
        textField.clearButtonMode = .whileEditing
        textField.maxCount_ty = 8
        return textField
    }()
    
    private var loginButton: TYButton_ty = {
        let button = TYButton_ty(.theme_ty)
        button.setTitle("登录", for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(16))
        return button
    }()
    private var registerButton: TYButton_ty = {
        let button = TYButton_ty(.second_ty)
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
        KFChatRequestManager.share.requestRecord(content: "登录页面")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(logoImageView)
        self.view.addSubview(accountTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(100), height: AdaptSize_ty(100)))
            make.top.equalToSuperview().offset(kNavigationHeight_ty + AdaptSize_ty(20))
            make.centerX.equalToSuperview()
        }
        accountTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(250), height: AdaptSize_ty(44)))
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(AdaptSize_ty(50))
        }
        passwordTextField.snp.makeConstraints { make in
            make.size.centerX.equalTo(accountTextField)
            make.top.equalTo(accountTextField.snp.bottom).offset(AdaptSize_ty(20))
        }
        loginButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(150), height: AdaptSize_ty(40)))
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(AdaptSize_ty(40))
        }
        registerButton.snp.makeConstraints { make in
            make.size.centerX.equalTo(loginButton)
            make.top.equalTo(loginButton.snp.bottom).offset(AdaptSize_ty(20))
        }
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.view.backgroundColor = .white
        self.customNavigationBar_ty?.isHidden = true
        self.loginButton.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
        self.registerButton.addTarget(self, action: #selector(registerEvent), for: .touchUpInside)
    }
    
    override func bindData_ty() {
        super.bindData_ty()
        KFUserModel.share.isLogin = false
    }
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    @objc
    private func registerEvent() {
        let vc = KFRegisterViewController()
        self.navigationController?.present(vc, animated: true)
    }
    
    @objc
    private func loginEvent() {
        guard let account = accountTextField.text, let password = passwordTextField.text else {
            kWindow_ty.toast_ty("请输入账号或密码")
            return
        }
        guard account == "13641665211", password == "abc123" else {
            kWindow_ty.toast_ty("账号或密码错误")
            return
        }
        KFUserModel.share.isLogin = true
        kWindow_ty.showLoading_ty()
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
            kWindow_ty.hideLoading_ty()
            let tbc = KFTabBarController()
            let nvc = TYNavigationController_ty(rootViewController: tbc)
            kWindow_ty.rootViewController = nvc
        }
        KFChatRequestManager.share.requestRecord(content: "登录成功")
    }
}
