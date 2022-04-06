//
//  KFSettingMoreViewController.swift
//  KiteFly
//
//  Created by apple on 2022/4/1.
//

import Foundation

class KFSettingMoreViewController: KFViewController {
    
    private var logout: KFButton = {
        let button = KFButton(.second)
        button.setTitle("退出登录", for: .normal)
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
        self.view.addSubview(logout)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "设置 -- 更多")
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "更多"
        self.logout.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
    }
    
    override func bindData() {
        super.bindData()
    }
    
    override func updateViewConstraints() {
        logout.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(35)))
            make.top.equalToSuperview().offset(AdaptSize(20) + kNavHeight)
            make.centerX.equalToSuperview()
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    @objc
    private func logoutAction() {
        kWindow.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            kWindow.hideLoading()
            let vc = KFLoginViewController()
            let nvc = KFNavigationController(rootViewController: vc)
            kWindow.rootViewController = nvc
        }
    }
    
}
