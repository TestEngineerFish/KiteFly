//
//  KFCommunityViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation

class KFCommunityViewController: KFViewController, UITableViewDelegate, UITableViewDataSource, KFCommunityCellDelegate {
    
    private let cellID = "kKFCommunityCell"
    private var modelList: [KFCommunityModel] = []
    
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
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "社区主页")
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(tableView)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title      = "社区"
        self.customNavigationBar?.rightTitle = "发布"
        self.customNavigationBar?.hideLeftView()
        self.tableView.delegate              = self
        self.tableView.dataSource            = self
        self.tableView.register(KFCommunityCell.classForCoder(), forCellReuseIdentifier: cellID)
    }
    
    override func rightAction() {
        super.rightAction()
        let vc = KFCommunityPublishViewController()
        self.navigationController?.push(vc: vc)
    }
    
    override func bindData() {
        super.bindData()
        self.modelList = KFFileManager.share.getJsonModelList(file: "CommunityList", type: KFCommunityModel.self) as? [KFCommunityModel] ?? []
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
        self.navigationController?.push(vc: vc)
    }
    
    // MARK: ==== KFCommunityCellDelegate ====
    func reportAction(model: KFCommunityModel) {
        let vc = KFCommunityReportViewController()
        self.navigationController?.present(vc, animated: true)
    }
    
    func remarkAction(model: KFCommunityModel) {
        let vc = KFCommunityRemarkViewController()
        vc.model = model
        self.navigationController?.push(vc: vc)
    }
}
