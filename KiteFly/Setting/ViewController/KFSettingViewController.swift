//
//  KFSettingViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation

enum KFSettingType: String {
    /// 我的帖子
    case notice     = "我的帖子"
    /// 已报名
    case register   = "已报名"
    ///  清理缓存
    case clear      = "清理缓存"
    /// 联系我们
    case contact    = "联系我们"
    /// 给我们评价
    case appraise   = "给我们评价"
    /// 用户协议
    case agreement  = "用户协议"
    /// 更多
    case more       = "更多"
    var icon: UIImage? {
        switch self {
        case .notice:
            return UIImage(named: "remark")
        case .register:
            return UIImage(named: "remark")
        case .clear:
            return UIImage(named: "remark")
        case .contact:
            return UIImage(named: "remark")
        case .appraise:
            return UIImage(named: "remark")
        case .agreement:
            return UIImage(named: "remark")
        case .more:
            return UIImage(named: "remark")
        }
    }
}

class KFSettingViewController: BPViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let cellID = "kKFSettingCell"
    private var model: KFUserModel?
    private let typeList: [KFSettingType] = [.notice, .register, .clear, .contact, .appraise, .agreement, .more]
    
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
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(tableView)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "设置"
        self.customNavigationBar?.hideLeftView()
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(KFSettingCell.classForCoder(), forCellReuseIdentifier: cellID)
    }
    
    override func bindData() {
        super.bindData()
        self.model = BPFileManager.share.getJsonModel(file: "UserModel", type: KFUserModel.self) as? KFUserModel
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
        return typeList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = KFSettingHeaderView()
        if let _model = self.model {
            headerView.setData(model: _model)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? KFSettingCell else {
            return UITableViewCell()
        }
        let type = self.typeList[indexPath.row]
        cell.setData(type: type)
        return cell
    }
}
