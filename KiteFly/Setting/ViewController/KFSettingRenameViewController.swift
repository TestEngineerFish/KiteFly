//
//  KFSettingRenameViewController.swift
//  KiteFly
//
//  Created by apple on 2022/4/1.
//

import Foundation

enum KFUserInfoType: String {
    case name    = "姓名"
    case sex     = "性别"
    case address = "地址"
    case remark  = "签名"
}

class KFSettingRenameViewController: KFViewController {
    
    var type: KFUserInfoType = .name
    
    private let textField: KFTextField = {
        let textField = KFTextField()
        textField.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        textField.textColor     = UIColor.black0
        textField.showLeftView  = true
        textField.showRightView = true
        textField.showBorder    = true
        return textField
    }()
    
    private var submitButton: KFButton = {
        let button = KFButton(.theme)
        button.setTitle("确定修改", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(15))
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
        KFChatRequestManager.share.requestRecord(content: "设置 -- 修改信息\(type.rawValue)")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(textField)
        self.view.addSubview(submitButton)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "修改\(self.type.rawValue)"
        self.submitButton.addTarget(self, action: #selector(renameAction), for: .touchUpInside)
        self.textField.placeholder = "请输入\(self.type.rawValue)"
    }
    
    override func bindData() {
        super.bindData()
        switch type {
        case .name:
            self.textField.text = KFUserModel.share.name
        case .sex:
            self.textField.text = KFUserModel.share.sex.str
        case .address:
            self.textField.text = KFUserModel.share.address
        case .remark:
            self.textField.text = KFUserModel.share.remark
        }
    }
    
    override func updateViewConstraints() {
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalToSuperview().offset(AdaptSize(20) + kNavHeight)
            make.height.equalTo(AdaptSize(40))
        }
        submitButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(35)))
            make.top.equalTo(textField.snp.bottom).offset(AdaptSize(20))
            make.centerX.equalToSuperview()
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    
    @objc
    private func renameAction() {
        guard let value = textField.text, value.isNotEmpty else {
            return
        }
        switch type {
        case .name:
            KFUserModel.share.name    = value
        case .address:
            KFUserModel.share.address = value
        case .remark:
            KFUserModel.share.remark  = value
        default:
            break
        }
        kWindow.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            kWindow.hideLoading()
            kWindow.toast("修改成功")
            self.navigationController?.pop()
        }
        
    }
    
}
