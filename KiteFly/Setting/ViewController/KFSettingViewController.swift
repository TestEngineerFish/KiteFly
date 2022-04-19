//
//  KFSettingViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation
import StoreKit
import STYKit

enum KFSettingType: String {
    case name       = "姓名"
    case avatar     = "头像"
    case sex        = "性别"
    case address    = "地址"
    case remark     = "个性签名"
    /// 我的帖子
    case notice     = "我的动态"
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
        case .name:
            return UIImage(named: "user_name")
        case .avatar:
            return UIImage(named: "user_avatar")
        case .sex:
            return UIImage(named: "user_sex")
        case .address:
            return UIImage(named: "user_address")
        case .remark:
            return UIImage(named: "user_remark")
        case .notice:
            return UIImage(named: "dynamic")
        case .register:
            return UIImage(named: "register")
        case .clear:
            return UIImage(named: "clear")
        case .contact:
            return UIImage(named: "contact")
        case .appraise:
            return UIImage(named: "appraise")
        case .agreement:
            return UIImage(named: "agreement")
        case .more:
            return UIImage(named: "more")
        }
    }
}

class KFSettingViewController: TYViewController_ty, UITableViewDelegate, UITableViewDataSource {
    
    private let cellID = "kKFSettingCell"
    private var model: KFUserModel?
    private let typeList: [KFSettingType] = [.notice, .register, .clear, .contact, .appraise, .agreement, .more]
    
    private var tableView: TYTableView_ty = {
        let tableView = TYTableView_ty(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight             = AdaptSize_ty(56)
        tableView.backgroundColor                = UIColor.white
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
        KFChatRequestManager.share.requestRecord(content: "设置主页")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(tableView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "设置"
        self.customNavigationBar_ty?.leftButton_ty.isHidden = true
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(KFSettingCell.classForCoder(), forCellReuseIdentifier: cellID)
    }
    
    override func bindData_ty() {
        super.bindData_ty()
        self.model = KFUserModel.share
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
    @objc
    private func clickUserInfo() {
        let vc = KFSettingUserDetailViewController()
        vc.model = self.model
        self.navigationController?.push_ty(vc_ty: vc)
    }
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = KFSettingHeaderView()
        if let _model = self.model {
            headerView.setData(model: _model)
        }
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(clickUserInfo))
        headerView.addGestureRecognizer(tapGes)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = self.typeList[indexPath.row]
        switch type {
        case .notice:
            let vc = KFSettingNoticeViewController()
            self.navigationController?.push_ty(vc_ty: vc)
        case .register:
            let vc = KFSettingMyRegisterViewController()
            self.navigationController?.push_ty(vc_ty: vc)
        case .clear:
            kWindow_ty.showLoading_ty()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                kWindow_ty.hideLoading_ty()
                kWindow_ty.toast_ty("清理完成")
            }
        case .contact:
            TYActionSheet_ty(title_ty: "联系我们").addItem_ty(title_ty: "邮箱：report@kangkanghui.com") {
                let email = "report@kangkanghui.com"
                if let url = URL(string: "mailto:\(email)") {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }.show_ty()
        case .appraise:
            SKStoreReviewController.requestReview()
        case .agreement:
            let vc = KFWebViewController()
            let path = Bundle.main.path(forResource: "Agreement", ofType: "html")
            vc.localHtml = path
            self.navigationController?.push_ty(vc_ty: vc)
        case .more:
            let vc = KFSettingMoreViewController()
            self.navigationController?.push_ty(vc_ty: vc)
        default:
            break
        }
        KFChatRequestManager.share.requestRecord(content: "设置 -- 点击\(type.rawValue)")
    }
}
