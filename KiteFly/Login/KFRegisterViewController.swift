//
//  KFRegisterViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation

class KFRegisterViewController: BPViewController {
    
    private let accountTextField: BPTextField = {
        let textField = BPTextField()
        textField.placeholder = "请输入账号"
        textField.font        = UIFont.regularFont(ofSize: AdaptSize(16))
        textField.textColor   = UIColor.black0
        textField.showBorder  = true
        textField.showLeftView = true
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    private let passwordTextField: BPTextField = {
        let textField = BPTextField()
        textField.placeholder = "请输入密码"
        textField.font        = UIFont.regularFont(ofSize: AdaptSize(16))
        textField.textColor   = UIColor.black0
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.showBorder  = true
        textField.showLeftView = true
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    private let confirmTextField: BPTextField = {
        let textField = BPTextField()
        textField.placeholder = "请再次输入密码"
        textField.font        = UIFont.regularFont(ofSize: AdaptSize(16))
        textField.textColor   = UIColor.black0
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.showBorder  = true
        textField.showLeftView = true
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private var registerButton: BPButton = {
        let button = BPButton(.theme)
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
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(accountTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(confirmTextField)
        self.view.addSubview(registerButton)
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
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "注册"
    }
    
    override func bindData() {
        super.bindData()
    }
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    
}
