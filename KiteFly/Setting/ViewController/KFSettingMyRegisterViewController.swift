//
//  KFSettingMyRegisterViewController.swift
//  KiteFly
//
//  Created by apple on 2022/4/1.
//

import Foundation
import STYKit

class KFSettingMyRegisterViewController: TYViewController_ty, UITableViewDelegate, UITableViewDataSource {
    
    private let noticCellID = "kKFSettingRegisterCell"
    
    private var noticeModelList = [KFNoticeModel]()
    
    private var tableView: TYTableView_ty = {
        let tableView = TYTableView_ty()
        tableView.estimatedRowHeight             = AdaptSize_ty(56)
        tableView.backgroundColor                = UIColor.clear
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
        KFChatRequestManager.share.requestRecord(content: "设置 -- 已报名")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight_ty)
        }
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "已报名"
        self.tableView.register(KFSettingRegisterCell.classForCoder(), forCellReuseIdentifier: noticCellID)
        self.tableView.delegate        = self
        self.tableView.dataSource      = self
    }
    
    override func bindData_ty() {
        super.bindData_ty()
        self.noticeModelList = []
        self.tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticeModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: noticCellID) as? KFSettingRegisterCell else {
            return UITableViewCell()
        }
        let model = noticeModelList[indexPath.row]
        cell.setData(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.noticeModelList[indexPath.row]
        let vc = KFNoticeDetailViewController()
        vc.model = model
        self.navigationController?.push_ty(vc_ty: vc)
    }
    
}
