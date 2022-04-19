//
//  KFCommunityPublishViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import IQKeyboardManager
import UIKit
import STYKit

class KFCommunityPublishViewController: TYViewController_ty, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let cellID = "kKFCommunityImageCell"
    private var modelList: [TYMediaImageModel_ty?] = []
    
    private let textView: IQTextView = {
        let textView = IQTextView()
        textView.placeholder = "请输入您的想法"
        textView.font        = UIFont.regular_ty(AdaptSize_ty(15))
        textView.textColor   = UIColor.black0
        return textView
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize                 = CGSize(width: AdaptSize_ty(60), height: AdaptSize_ty(60))
        layout.minimumLineSpacing       = AdaptSize_ty(10)
        layout.minimumInteritemSpacing  = AdaptSize_ty(10)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    private var submitButton: TYButton_ty = {
        let button = TYButton_ty(.theme_ty)
        button.setTitle("提交", for: .normal)
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
        KFChatRequestManager.share.requestRecord(content: "社区主页 -- 发布帖子页面")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(textView)
        self.view.addSubview(collectionView)
        self.view.addSubview(submitButton)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "发布动态"
        self.customNavigationBar_ty?.setRightTitle_ty(text_ty: "?")
        self.collectionView.delegate    = self
        self.collectionView.dataSource  = self
        self.collectionView.register(KFCommunityImageCell.classForCoder(), forCellWithReuseIdentifier: cellID)
        self.submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        self.view.backgroundColor = UIColor.gray0
    }
    
    override func rightAction_ty() {
        super.rightAction_ty()
        TYAlertManager_ty.share_ty.oneButton_ty(title_ty: "提示", description_ty: "发布内容必须遵守法律法规，否则将被移除，且追究法律责任。\n1、禁止发布传达、传送破坏社会的违法信息。\n2、不得侵犯他人隐私权。\n3、不得发布恶意虚构事实，欺骗他人的信息。\n4、不得涉及黄、赌、毒。\n5、不得发布政治敏感内容。\n6、禁止发布其他违法行为。", buttonName_ty: "知道了", closure_ty: nil).show_ty()
    }
    
    override func bindData_ty() {
        super.bindData_ty()
        self.modelList = [nil]
        self.collectionView.reloadData()
    }
    
    override func updateViewConstraints() {
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.top.equalToSuperview().offset(kNavigationHeight_ty + AdaptSize_ty(20))
            make.height.equalTo(AdaptSize_ty(200))
        }
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.top.equalTo(textView.snp.bottom).offset(AdaptSize_ty(15))
            let isRound = modelList.count % 3 > 0
            var line    = modelList.count/3
            line        = isRound ? line + 1 : line
            let h       = CGFloat(line) * AdaptSize_ty(90) - AdaptSize_ty(10)
            make.height.equalTo(h)
        }
        submitButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(200), height: AdaptSize_ty(36)))
            make.top.equalTo(collectionView.snp.bottom).offset(AdaptSize_ty(20))
            make.centerX.equalToSuperview()
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    @objc
    private func submitAction() {
        guard textView.text.isNotEmpty_ty else {
            kWindow_ty.toast_ty("请输入内容")
            return
        }
        kWindow_ty.showLoading_ty()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            kWindow_ty.hideLoading_ty()
            kWindow_ty.toast_ty("发布成功，审核通过后可展示在社区～")
            self.navigationController?.pop_ty()
        }
    }
    
    // MARK: ==== UICollectionViewDelegate, UICollectionViewDataSource ====
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? KFCommunityImageCell else {
            return UICollectionViewCell()
        }
        let model = self.modelList[indexPath.row]
        cell.setImage(image: model?.image_ty)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TYPhotoManager_ty.share_ty.show_ty(complete_ty: { modelList in
            self.modelList.removeLast()
            self.modelList += modelList as? [TYMediaImageModel_ty] ?? []
            self.modelList.append(nil)
            self.collectionView.reloadData()
        }, maxCount_ty: 9)
    }
}
