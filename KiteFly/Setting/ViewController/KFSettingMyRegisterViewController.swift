//
//  KFSettingMyRegisterViewController.swift
//  KiteFly
//
//  Created by apple on 2022/4/1.
//

import Foundation

class KFSettingMyRegisterViewController: BPViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let noticCellID = "kKFSettingRegisterCell"
    
    private var noticeModelList = [KFNoticeModel]()
    
    private var tableView: BPTableView = {
        let tableView = BPTableView()
        tableView.estimatedRowHeight             = AdaptSize(56)
        tableView.backgroundColor                = UIColor.clear
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
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "已报名"
        self.tableView.register(KFSettingRegisterCell.classForCoder(), forCellReuseIdentifier: noticCellID)
        self.tableView.delegate        = self
        self.tableView.dataSource      = self
    }
    
    override func bindData() {
        super.bindData()
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
        self.navigationController?.push(vc: vc)
    }
    
}
