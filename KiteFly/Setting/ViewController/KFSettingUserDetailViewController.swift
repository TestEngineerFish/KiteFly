//
//  KFSettingUserDetailViewController.swift
//  KiteFly
//
//  Created by apple on 2022/4/2.
//

import Foundation

class KFSettingUserDetailViewController: BPViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let cellID = "kKFSettingUserDetailCell"
    private var typeList: [KFSettingType] = [.name, .sex, .address, .remark]
    var model: KFUserModel?
    
    private var tableView: BPTableView = {
        let tableView = BPTableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight             = AdaptSize(56)
        tableView.backgroundColor                = UIColor.gray0
        tableView.separatorStyle                 = .none
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bindData()
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(tableView)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "个人主页"
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(KFSettingUserDetailCell.classForCoder(), forCellReuseIdentifier: cellID)
    }
    
    override func bindData() {
        super.bindData()
        self.tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
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
        let type = self.typeList[indexPath.row]
        switch type {
        case .name:
            let vc = KFSettingRenameViewController()
            vc.type = .name
            UIViewController.currentNavigationController?.push(vc: vc)
        case .sex:
            BPActionSheet(title: "选择性别").addItem(title: "男") {
                KFUserModel.share.sex   = .man
                self.model?.sex         = .man
                tableView.reloadData()
            }.addItem(title: "女") {
                KFUserModel.share.sex   = .woman
                self.model?.sex         = .woman
                tableView.reloadData()
            }.addItem(title: "保密") {
                KFUserModel.share.sex   = .unknown
                self.model?.sex         = .unknown
                tableView.reloadData()
            }.show()
        case .address:
            let vc = KFSettingRenameViewController()
            vc.type = .address
            UIViewController.currentNavigationController?.push(vc: vc)
        case .remark:
            let vc = KFSettingRenameViewController()
            vc.type = .remark
            UIViewController.currentNavigationController?.push(vc: vc)
        default:
            break
        }
        
    }
}
