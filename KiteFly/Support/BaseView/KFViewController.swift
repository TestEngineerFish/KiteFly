//
//  KFViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import SnapKit
import STYKit

open class KFViewController: UIViewController, KFNavigationBarDelegate {
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }

    open override var title: String? {
        didSet {
            self.customNavigationBar?.title = title
        }
    }
    
    deinit {
//        #if DEBUG
        print(self.classForCoder, "资源释放")
//        #endif
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("==== \(self.classForCoder) 内存告警 ====")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.useCustomNavigationBar()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.setFullScreenPopGesture()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    open func createSubviews() {}

    open func bindProperty() {}

    open func bindData() {}
    
    /// 更新UI颜色、图片
    open func updateUI() {}

    open func registerNotification() {}

    open func setFullScreenPopGesture() {}
    
    
    // TODO: ==== CustomNavigationBar ====
    private struct AssociatedKeys {
        static var customeNavigationBar: String = "kCustomeNavigationBar"
    }
    
    public func useCustomNavigationBar() {
        let navBar = self.createCustomNavigationBar()
        self.view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kNavHeight)
        }
        self.customNavigationBar?.delegate = self
    }
    
    public var customNavigationBar: KFNavigationBar? {
        return objc_getAssociatedObject(self, &AssociatedKeys.customeNavigationBar) as? KFNavigationBar
    }
    
    // MARK: ++++++++++ Private ++++++++++
    private func createCustomNavigationBar() -> KFNavigationBar {
        let cnb = KFNavigationBar()
        objc_setAssociatedObject(self, &AssociatedKeys.customeNavigationBar, cnb, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return cnb
    }
    
    // MARK: ==== BPNavigationBarDelegate ====
    open func leftAction() {
        self.view.endEditing(true)
        if let nav = self.navigationController {
            nav.pop()
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    open func rightAction() {
        self.view.endEditing(true)
        print("Click right button in custom navigation bar")
    }
}
