//
//  KFNoticeDetailViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import STYKit

class KFNoticeDetailViewController: TYViewController_ty {
    
    var model:KFNoticeModel?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator   = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private var titleLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.DIN_ty(AdaptSize_ty(20))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private var imageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode         = .scaleAspectFill
        imageView.layer.cornerRadius  = AdaptSize_ty(10)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var byLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regular_ty(AdaptSize_ty(16))
        label.textAlignment = .right
        return label
    }()
    private var contentLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regular_ty(AdaptSize_ty(16))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private var registerButton: TYButton_ty = {
        let button = TYButton_ty(.theme_ty)
        button.setTitle("马上报名", for: .normal)
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
        KFChatRequestManager.share.requestRecord(content: "主页首页 -- 通知详情")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(scrollView)
        self.view.addSubview(registerButton)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(imageView)
        scrollView.addSubview(byLabel)
        scrollView.addSubview(contentLabel)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty      = "详情"
        self.customNavigationBar_ty?.setRightTitle_ty(text_ty: "参与列表")
        self.registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
    }
    
    override func rightAction_ty() {
        super.rightAction_ty()
        
        guard let _model = model, _model.isValid == true else {
            TYAlertManager_ty.share_ty.oneButton_ty(title_ty: "提示", description_ty: "当前活动已过期", buttonName_ty: "知道了", closure_ty: nil).show_ty()
            return
        }
        let vc = KFRegisterListViewController()
        vc.modelList = _model.userModelList
        self.navigationController?.push_ty(vc_ty: vc)
    }
    
    override func bindData_ty() {
        super.bindData_ty()
        guard let model = self.model else {
            return
        }
        self.titleLabel.text = model.title
        self.imageView.setImage_ty(imageStr_ty: model.icon)
        self.byLabel.text      = model.name
        self.contentLabel.text = model.content + "\n\n\n联系方式：\(model.contact)\n\n详细地址：\(model.address)\n\n\n\n"
        if !model.isValid {
            TYAlertManager_ty.share_ty.oneButton_ty(title_ty: "提示", description_ty: "当前活动已过期", buttonName_ty: "知道了", closure_ty: nil).show_ty()
        }
    }
    
    override func updateViewConstraints() {
        scrollView.frame = CGRect(x: 0, y: kNavigationHeight_ty, width: kScreenWidth_ty, height: kScreenHeight_ty - kNavigationHeight_ty)
        scrollView.contentSize = scrollView.size_ty
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.top.equalToSuperview().offset(AdaptSize_ty(15))
            make.centerX.equalToSuperview()
        }
        byLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize_ty(15))
        }
        imageView.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(AdaptSize_ty(120))
            make.top.equalTo(byLabel.snp.bottom).offset(AdaptSize_ty(20))
        }
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(imageView.snp.bottom).offset(AdaptSize_ty(20))
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-20))
        }
        registerButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(100), height: AdaptSize_ty(40)))
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-20) - kSafeBottomMargin_ty)
            make.centerX.equalToSuperview()
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    @objc
    private func registerAction() {
        guard let _model = model, _model.isValid == true else {
            TYAlertManager_ty.share_ty.oneButton_ty(title_ty: "提示", description_ty: "当前活动已过期", buttonName_ty: "知道了", closure_ty: nil).show_ty()
            return
        }
        kWindow_ty.showLoading_ty()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            kWindow_ty.hideLoading_ty()
            kWindow_ty.toast_ty("已报名，请等待对方审核")
            let vc = KFRegisterListViewController()
            self.navigationController?.push_ty(vc_ty: vc)
        }
    }
}
