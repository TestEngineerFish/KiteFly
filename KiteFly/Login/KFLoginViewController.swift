//
//  KFLoginViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation
//import UIKit

class KFLoginViewController: BPViewController {
    
    private var logoImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = AdaptSize(10)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
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
    
    private var loginButton: BPButton = {
        let button = BPButton(.theme)
        button.setTitle("登录", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(16))
        return button
    }()
    private var registerButton: BPButton = {
        let button = BPButton(.second)
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
        self.view.addSubview(logoImageView)
        self.view.addSubview(accountTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(100)))
            make.top.equalToSuperview().offset(kNavHeight + AdaptSize(20))
            make.centerX.equalToSuperview()
        }
        accountTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(250), height: AdaptSize(44)))
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(AdaptSize(50))
        }
        passwordTextField.snp.makeConstraints { make in
            make.size.centerX.equalTo(accountTextField)
            make.top.equalTo(accountTextField.snp.bottom).offset(AdaptSize(20))
        }
        loginButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(150), height: AdaptSize(40)))
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(AdaptSize(40))
        }
        registerButton.snp.makeConstraints { make in
            make.size.centerX.equalTo(loginButton)
            make.top.equalTo(loginButton.snp.bottom).offset(AdaptSize(20))
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.view.backgroundColor = .white
        self.customNavigationBar?.isHidden = true
        self.loginButton.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
        self.registerButton.addTarget(self, action: #selector(registerEvent), for: .touchUpInside)
    }
    
    override func bindData() {
        super.bindData()
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
        let tbc = BPTabBarController()
        let nvc = BPNavigationController(rootViewController: tbc)
        kWindow.rootViewController = nvc
    }
}
