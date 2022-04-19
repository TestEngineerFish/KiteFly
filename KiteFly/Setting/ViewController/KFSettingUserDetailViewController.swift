//
//  KFSettingUserDetailViewController.swift
//  KiteFly
//
//  Created by apple on 2022/4/2.
//

import Foundation
import STYKit

class KFSettingUserDetailViewController: TYViewController_ty, UITableViewDelegate, UITableViewDataSource {
    
    private let cellID = "kKFSettingUserDetailCell"
    private var typeList: [KFSettingType] = [.name, .sex, .address, .remark]
    var model: KFUserModel?
    
    private var tableView: TYTableView_ty = {
        let tableView = TYTableView_ty(frame: .zero, style: .grouped)
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
        self.bindData_ty()
        KFChatRequestManager.share.requestRecord(content: "设置 -- 个人信息")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(tableView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "个人主页"
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(KFSettingUserDetailCell.classForCoder(), forCellReuseIdentifier: cellID)
    }
    
    override func bindData_ty() {
        super.bindData_ty()
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
        return self.typeList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = KFSettingUserHeaderView()
        headerView.setData(model: model)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? KFSettingUserDetailCell else {
            return UITableViewCell()
        }
        let type = self.typeList[indexPath.row]
        cell.setData(type: type, model: self.model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _model = self.model, _model.id == KFUserModel.share.id else {
            return
        }
        let type = self.typeList[indexPath.row]
        switch type {
        case .name:
            let vc = KFSettingRenameViewController()
            vc.type = .name
            currentNVC_ty?.push_ty(vc_ty: vc)
        case .sex:
            TYActionSheet_ty(title_ty: "选择性别").addItem_ty(title_ty: "男") {
                KFUserModel.share.sex   = .man
                self.model?.sex         = .man
                tableView.reloadData()
            }.addItem_ty(title_ty: "女") {
                KFUserModel.share.sex   = .woman
                self.model?.sex         = .woman
                tableView.reloadData()
            }.addItem_ty(title_ty: "保密") {
                KFUserModel.share.sex   = .unknown
                self.model?.sex         = .unknown
                tableView.reloadData()
            }.show_ty()
        case .address:
            let vc = KFSettingRenameViewController()
            vc.type = .address
            currentNVC_ty?.push_ty(vc_ty: vc)
        case .remark:
            let vc = KFSettingRenameViewController()
            vc.type = .remark
            currentNVC_ty?.push_ty(vc_ty: vc)
        default:
            break
        }
        
    }
}
