//
//  KFSettingRenameViewController.swift
//  KiteFly
//
//  Created by apple on 2022/4/1.
//

import Foundation
import STYKit

enum KFUserInfoType: String {
    case name    = "姓名"
    case sex     = "性别"
    case address = "地址"
    case remark  = "签名"
}

class KFSettingRenameViewController: TYViewController_ty {
    
    var type: KFUserInfoType = .name
    
    private let textField: TYTextField_ty = {
        let textField = TYTextField_ty(type_ty: .normal_ty)
        textField.font          = UIFont.regular_ty(AdaptSize_ty(15))
        textField.textColor     = UIColor.black0
        textField.showLeftView_ty  = true
        textField.showRightView_ty = true
        textField.showBorder_ty    = true
        return textField
    }()
    
    private var submitButton: TYButton_ty = {
        let button = TYButton_ty(.theme_ty)
        button.setTitle("确定修改", for: .normal)
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
        KFChatRequestManager.share.requestRecord(content: "设置 -- 修改信息\(type.rawValue)")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(textField)
        self.view.addSubview(submitButton)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "修改\(self.type.rawValue)"
        self.submitButton.addTarget(self, action: #selector(renameAction), for: .touchUpInside)
        self.textField.placeholder = "请输入\(self.type.rawValue)"
    }
    
    override func bindData_ty() {
        super.bindData_ty()
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
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.top.equalToSuperview().offset(AdaptSize_ty(20) + kNavigationHeight_ty)
            make.height.equalTo(AdaptSize_ty(40))
        }
        submitButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(100), height: AdaptSize_ty(35)))
            make.top.equalTo(textField.snp.bottom).offset(AdaptSize_ty(20))
            make.centerX.equalToSuperview()
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    
    @objc
    private func renameAction() {
        guard let value = textField.text, value.isNotEmpty_ty else {
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
        kWindow_ty.showLoading_ty()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            kWindow_ty.hideLoading_ty()
            kWindow_ty.toast_ty("修改成功")
            self.navigationController?.pop_ty()
        }
        
    }
    
}
