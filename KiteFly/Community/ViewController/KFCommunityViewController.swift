//
//  KFCommunityViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import STYKit

class KFCommunityViewController: TYViewController_ty, UITableViewDelegate, UITableViewDataSource, KFCommunityCellDelegate {
    
    private let cellID = "kKFCommunityCell"
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
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "社区主页")
    }

    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(tableView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty      = "社区"
        self.customNavigationBar_ty?.setRightTitle_ty(text_ty: "发布")
        self.customNavigationBar_ty?.leftButton_ty.isHidden = true
        self.tableView.delegate              = self
        self.tableView.dataSource            = self
        self.tableView.register(KFCommunityCell.classForCoder(), forCellReuseIdentifier: cellID)
    }
    
    override func rightAction_ty() {
        super.rightAction_ty()
        let vc = KFCommunityPublishViewController()
        self.navigationController?.push_ty(vc_ty: vc)
    }
    
    override func bindData_ty() {
        super.bindData_ty()
        self.modelList = TYFileManager_ty.share_ty.getJsonModelList_ty(file_ty: "CommunityList", type_ty: KFCommunityModel.self) as? [KFCommunityModel] ?? []
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? KFCommunityCell else {
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
    
    // MARK: ==== KFCommunityCellDelegate ====
    func reportAction(model: KFCommunityModel) {
        let vc = KFCommunityReportViewController()
        self.navigationController?.present(vc, animated: true)
    }
    
    func remarkAction(model: KFCommunityModel) {
        let vc = KFCommunityRemarkViewController()
        vc.model = model
        self.navigationController?.push_ty(vc_ty: vc)
    }
}
