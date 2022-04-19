//
//  KFHomeViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation
import STYKit


class KFHomeViewController: TYViewController_ty, UITableViewDelegate, UITableViewDataSource {
    
    private let noticCellID = "kKFHomeNoticCell"
    
    private var noticeModelList = [KFNoticeModel]()
    
    private var tableView: TYTableView_ty = {
        let tableView = TYTableView_ty(frame: .zero, style: .grouped)
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
        self.updateUI_ty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "主页首页")
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
        self.customNavigationBar_ty?.title_ty = "风筝汇"
        self.customNavigationBar_ty?.leftButton_ty.isHidden = true
        self.tableView.register(KFHomeNoticCell.classForCoder(), forCellReuseIdentifier: noticCellID)
        self.tableView.delegate        = self
        self.tableView.dataSource      = self
    }
    
    override func bindData_ty() {
        super.bindData_ty()
        self.noticeModelList = TYFileManager_ty.share_ty.getJsonModelList_ty(file_ty: "NoticModelList", type_ty: KFNoticeModel.self) as? [KFNoticeModel] ?? []
        self.tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func updateUI_ty() {
        super.updateUI_ty()
        self.view.backgroundColor = .white
        
    }
    
    // MARK: ==== Event ====
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticeModelList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = KFHomeHeaderView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: noticCellID) as? KFHomeNoticCell else {
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
