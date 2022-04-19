//
//  KFSettingNoticeViewController.swift
//  KiteFly
//
//  Created by apple on 2022/4/1.
//

import Foundation
import STYKit

class KFSettingNoticeViewController: TYViewController_ty, UITableViewDelegate, UITableViewDataSource, KFSettingNoticeCellDelegate {
    
    private let cellID = "kKFSettingNoticeCell"
    private var modelList: [KFCommunityModel] = []
    
    private var tableView: TYTableView_ty = {
        let tableView = TYTableView_ty()
        tableView.estimatedRowHeight             = AdaptSize_ty(56)
        tableView.backgroundColor                = UIColor.gray0
        tableView.separatorStyle                 = .none
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.bindData_ty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "设置 -- 我的动态")
    }

    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(tableView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty      = "我的动态"
        self.customNavigationBar_ty?.setRightTitle_ty(text_ty: "发布")
        self.tableView.delegate              = self
        self.tableView.dataSource            = self
        self.tableView.register(KFSettingNoticeCell.classForCoder(), forCellReuseIdentifier: cellID)
    }
    
    override func rightAction_ty() {
        super.rightAction_ty()
        let vc = KFCommunityPublishViewController()
        self.navigationController?.push_ty(vc_ty: vc)
    }
    
    override func bindData_ty() {
        super.bindData_ty()
        self.modelList = []
        self.tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight_ty)
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? KFSettingNoticeCell else {
            return UITableViewCell()
        }
        let model = self.modelList[indexPath.row]
        cell.setData(model: model)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = KFCommunityDetailViewController()
        let model = self.modelList[indexPath.row]
        vc.model = model
        self.navigationController?.push_ty(vc_ty: vc)
    }
    
    // MARK: ==== KFSettingNoticeCellDelegate ====
    func remarkAction(model: KFCommunityModel) {
        let vc = KFCommunityRemarkViewController()
        vc.model = model
        self.navigationController?.push_ty(vc_ty: vc)
    }
}
