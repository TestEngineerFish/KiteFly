//
//  KFRegisterListViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation

class KFRegisterListViewController: KFViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let cellID = "kKFHomeMemberListCell"
    var modelList: [KFUserModel] = []
    
    private var tableView: KFTableView = {
        let tableView = KFTableView()
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
        KFChatRequestManager.share.requestRecord(content: "主页首页 -- 查看报名人列表")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(tableView)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "报名人员列表"
        self.tableView.delegate         = self
        self.tableView.dataSource       = self
        self.tableView.register(KFHomeMemberListCell.classForCoder(), forCellReuseIdentifier: cellID)
    }
    
    override func bindData() {
        super.bindData()
//        self.modelList = KFFileManager.share.getJsonModelList(file: "UserModelList", type: KFUserModel.self) as? [KFUserModel] ?? []
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
        return self.modelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? KFHomeMemberListCell else {
            return UITableViewCell()
        }
        let model = self.modelList[indexPath.row]
        cell.setData(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.modelList[indexPath.row]
        let vc = KFSettingUserDetailViewController()
        vc.model = model
        self.navigationController?.push(vc: vc)
    }
}
