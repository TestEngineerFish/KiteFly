//
//  KFSettingMoreViewController.swift
//  KiteFly
//
//  Created by apple on 2022/4/1.
//

import Foundation
import STYKit

class KFSettingMoreViewController: TYViewController_ty {
    
    private var logout: TYButton_ty = {
        let button = TYButton_ty(.second_ty)
        button.setTitle("退出登录", for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(15))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.bindData_ty()
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(logout)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "设置 -- 更多")
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "更多"
        self.logout.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
    }
    
    override func bindData_ty() {
        super.bindData_ty()
    }
    
    override func updateViewConstraints() {
        logout.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(100), height: AdaptSize_ty(35)))
            make.top.equalToSuperview().offset(AdaptSize_ty(20) + kNavigationHeight_ty)
            make.centerX.equalToSuperview()
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    @objc
    private func logoutAction() {
        kWindow_ty.showLoading_ty()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            kWindow_ty.hideLoading_ty()
            let vc = KFLoginViewController()
            let nvc = TYNavigationController_ty(rootViewController: vc)
            kWindow_ty.rootViewController = nvc
        }
    }
    
}
