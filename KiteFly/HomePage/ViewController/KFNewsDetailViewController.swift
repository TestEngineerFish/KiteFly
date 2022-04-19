//
//  KFNewsDetailViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation
import STYKit
import UIKit

class KFNewsDetailViewController: TYViewController_ty {
    
    var model: KFNewsModel?
    
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
    private var timeLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regular_ty(AdaptSize_ty(13))
        label.textAlignment = .right
        return label
    }()
    private var imageView: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius  = AdaptSize_ty(10)
        return imageView
    }()
    private var contentLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regular_ty(AdaptSize_ty(15))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindData_ty()
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "主页首页 -- 新闻详情")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(imageView)
        scrollView.addSubview(contentLabel)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty      = "详情"
        self.customNavigationBar_ty?.setRightTitle_ty(text_ty: "收藏")
    }
    
    override func rightAction_ty() {
        super.rightAction_ty()
        self.view.toast_ty("收藏成功")
    }
    
    override func bindData_ty() {
        super.bindData_ty()
        guard let model = self.model else {
            return
        }
        self.titleLabel.text   = model.title
        self.timeLabel.text    = model.time?.timeStr_ty()
        self.contentLabel.text = model.content
        self.imageView.setImage_ty(imageStr_ty: model.icon)
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
        timeLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize_ty(5))
            make.height.equalTo(timeLabel.font.lineHeight)
        }
        imageView.snp.makeConstraints { make in
            make.width.equalTo(kScreenWidth_ty - AdaptSize_ty(30))
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(AdaptSize_ty(20))
            make.height.equalTo(AdaptSize_ty(120))
        }
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(AdaptSize_ty(20))
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-20))
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    
}
