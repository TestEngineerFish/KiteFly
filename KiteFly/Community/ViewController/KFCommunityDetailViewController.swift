//
//  KFCommunityDetailViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import STYKit

class KFCommunityDetailViewController: TYViewController_ty, UITableViewDelegate, UITableViewDataSource, KFCommunityRemarkCellDelegate, KFCommunityHeaderViewDelegate {
    
    var model: KFCommunityModel?
    private let cellID = "kKFCommunityRemarkCell"
    
    private var tableView: TYTableView_ty = {
        let tableView = TYTableView_ty(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight             = AdaptSize_ty(56)
        tableView.backgroundColor                = UIColor.gray0
        tableView.separatorStyle                 = .none
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    private var remarkButton: TYButton_ty = {
        let button = TYButton_ty(.theme_ty)
        button.setTitle("评论", for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(15))
        button.layer.setDefaultShadow_ty()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.bindData_ty()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "社区主页 -- 帖子详情")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(tableView)
        self.view.addSubview(remarkButton)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "详情"
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(KFCommunityRemarkCell.classForCoder(), forCellReuseIdentifier: cellID)
        self.remarkButton.addTarget(self, action: #selector(remarkAction), for: .touchUpInside)
    }
    
    override func bindData_ty() {
        super.bindData_ty()
    }
    
    override func updateViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight_ty)
        }
        remarkButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(200), height: AdaptSize_ty(36)))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-20) - kSafeBottomMargin_ty)
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    @objc
    private func remarkAction() {
        let vc = KFCommunityRemarkViewController()
        self.navigationController?.push_ty(vc_ty: vc)
    }
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.remarkList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = KFCommunityHeaderView()
        if let model = self.model {
            headerView.setData(model: model)
        }
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? KFCommunityRemarkCell, let remarkList = self.model?.remarkList else {
            return UITableViewCell()
        }
        let model = remarkList[indexPath.row]
        cell.setData(model: model)
        cell.delegate = self
        return cell
    }
    
    // MARK: ==== KFCommunityRemarkCellDelegate ====
    func replyRemarkAction(model: KFCommunityRemarkModel) {
        let vc = KFCommunityReplyRemarkViewController()
        vc.model = model
        self.navigationController?.present(vc, animated: true)
    }
    
    func reportRemarkAction(model: KFCommunityRemarkModel) {
        let vc = KFCommunityReportViewController()
        vc.id = model.id
        self.navigationController?.present(vc, animated: true)
    }
    
    // MARK: ==== KFCommunityHeaderViewDelegate ====
    func reportAction(model: KFCommunityModel) {
        let vc = KFCommunityReportViewController()
        self.navigationController?.present(vc, animated: true)
    }
    
    func clickAvatarAction(model: KFUserModel) {
        let vc = KFSettingUserDetailViewController()
        vc.model = self.model?.userModel
        self.navigationController?.push_ty(vc_ty: vc)
    }
}
