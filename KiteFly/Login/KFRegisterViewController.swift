//
//  KFRegisterViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation

class KFRegisterViewController: KFViewController {
    
    private let accountTextField: KFTextField = {
        let textField = KFTextField()
        textField.placeholder = "请输入账号"
        textField.font        = UIFont.regularFont(ofSize: AdaptSize(16))
        textField.textColor   = UIColor.black0
        textField.showBorder  = true
        textField.showLeftView = true
        textField.clearButtonMode = .whileEditing
        textField.maxLengthBP = 11
        return textField
    }()
    private let passwordTextField: KFTextField = {
        let textField = KFTextField()
        textField.placeholder = "请输入密码"
        textField.font        = UIFont.regularFont(ofSize: AdaptSize(16))
        textField.textColor   = UIColor.black0
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.showBorder  = true
        textField.showLeftView = true
        textField.clearButtonMode = .whileEditing
        textField.maxLengthBP = 8
        return textField
    }()
    private let confirmTextField: KFTextField = {
        let textField = KFTextField()
        textField.placeholder = "请再次输入密码"
        textField.font        = UIFont.regularFont(ofSize: AdaptSize(16))
        textField.textColor   = UIColor.black0
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.showBorder  = true
        textField.showLeftView = true
        textField.clearButtonMode = .whileEditing
        textField.maxLengthBP = 8
        return textField
    }()
    
    private var registerButton: KFButton = {
        let button = KFButton(.theme)
        button.setTitle("注册", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(16))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "注册页面")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(accountTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(confirmTextField)
        self.view.addSubview(registerButton)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "注册"
        self.customNavigationBar?.hideLeftView()
        self.registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
    }
    
    override func bindData() {
        super.bindData()
    }
    
    override func updateViewConstraints() {
        accountTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(250), height: AdaptSize(44)))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight + AdaptSize(100))
        }
        passwordTextField.snp.makeConstraints { make in
            make.size.centerX.equalTo(accountTextField)
            make.top.equalTo(accountTextField.snp.bottom).offset(AdaptSize(20))
        }
        confirmTextField.snp.makeConstraints { make in
            make.size.centerX.equalTo(accountTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(AdaptSize(20))
        }
        registerButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(150), height: AdaptSize(40)))
            make.centerX.equalToSuperview()
            make.top.equalTo(confirmTextField.snp.bottom).offset(AdaptSize(40))
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    @objc
    private func registerAction() {
        guard let account = accountTextField.text, let password0 = passwordTextField.text, let password1 = confirmTextField.text, account.isNotEmpty, password0.isNotEmpty, password1.isNotEmpty else {
            kWindow.toast("账号密码不能为空")
            return
        }
        guard password0 == password1 else {
            kWindow.toast("密码不一致")
            return
        }
        kWindow.showLoading()
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            kWindow.hideLoading()
            KFAlertManager.share.oneButton(title: "提示", description: "账号已存在，请直接登录", buttonName: "知道了") {
                self.dismiss(animated: true)
            }.show()
        }
    }
    
}
