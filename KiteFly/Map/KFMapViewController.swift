//
//  KFMapViewController.swift
//  KiteFly
//
//  Created by apple on 2022/4/19.
//

import Foundation
import STYKit
import Lottie

class KFMapViewController: TYViewController_ty, UITableViewDelegate, UITableViewDataSource {
    
    private var modelList: [String] = []
    
    private var tableView: TYTableView_ty = {
        let tableView = TYTableView_ty()
        tableView.estimatedRowHeight             = AdaptSize_ty(56)
        tableView.backgroundColor                = UIColor.gray0
        tableView.separatorStyle                 = .none
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.emptyView_ty = TYEmptyView_ty(image: nil, hintText_ty: "暂无足迹数据")
        return tableView
    }()
    private var launchView: AnimationView = {
        let view = AnimationView(name: "remind")
        view.loopMode = .loop
        view.play()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private var iconView: AnimationView = {
        let view = AnimationView(name: "map")
        view.size_ty = CGSize(width: AdaptSize_ty(60), height: AdaptSize_ty(60))
        view.loopMode = .loop
        view.play()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.bindData_ty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.launchView.isHidden {
            self.launchView.play()
        }
        self.iconView.play()
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(tableView)
        self.view.addSubview(launchView)
        self.view.addSubview(iconView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "我的足迹"
        self.customNavigationBar_ty?.setRightTitle_ty(text_ty: "添加")
        self.customNavigationBar_ty?.leftButton_ty.isHidden = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapLaunchAction))
        self.launchView.addGestureRecognizer(tapGes)
        self.tableView.delegate   = self
        self.tableView.dataSource = self
    }
    
    override func rightAction_ty() {
        super.rightAction_ty()
        let vc = KFMapAddViewController()
        vc.editBlock = { text in
            self.modelList.append(text)
            self.tableView.reloadData()
        }
        self.present(vc, animated: true)
    }
    
    override func bindData_ty() {
        super.bindData_ty()
    }
    
    override func updateViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight_ty)
        }
        launchView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        iconView.frame = CGRect(x: (kScreenWidth_ty - iconView.width_ty)/2, y: kScreenHeight_ty - iconView.height_ty - kSafeBottomMargin_ty - 49.0 - AdaptSize_ty(5), width: iconView.width_ty, height: iconView.height_ty)
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    @objc private func tapLaunchAction() {
        self.launchView.isHidden = true
        UIView.animate(withDuration: 1.5) {
            self.iconView.frame = CGRect(x: kScreenWidth_ty - self.iconView.width_ty - AdaptSize_ty(15), y: kScreenHeight_ty - self.iconView.height_ty - kSafeBottomMargin_ty - 49.0 - AdaptSize_ty(5), width: self.iconView.width_ty, height: self.iconView.height_ty)
        }
    }
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = self.modelList[indexPath.row]
        return cell
    }
    
}
