//
//  KFNoticeDetailViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/31.
//

import Foundation

class KFNoticeDetailViewController: BPViewController {
    
    var model:KFNoticeModel?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator   = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private var titleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptSize(20))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private var imageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode         = .scaleAspectFill
        imageView.layer.cornerRadius  = AdaptSize(10)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var byLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        label.textAlignment = .right
        return label
    }()
    private var contentLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private var registerButton: BPButton = {
        let button = BPButton(.theme)
        button.setTitle("马上报名", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(16))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(scrollView)
        self.view.addSubview(registerButton)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(imageView)
        scrollView.addSubview(byLabel)
        scrollView.addSubview(contentLabel)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title      = "详情"
        self.customNavigationBar?.rightTitle = "参与列表"
        self.registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
    }
    
    override func rightAction() {
        super.rightAction()
        let vc = KFRegisterListViewController()
        self.navigationController?.push(vc: vc)
    }
    
    override func bindData() {
        super.bindData()
        guard let model = self.model else {
            return
        }
        self.titleLabel.text = model.title
        self.imageView.setImage(with: model.icon)
        self.byLabel.text      = model.name
        self.contentLabel.text = model.content + "\n\n\n联系方式：\(model.contact)\n\n详细地址：\(model.address)\n\n\n\n"
    }
    
    override func updateViewConstraints() {
        scrollView.frame = CGRect(x: 0, y: kNavHeight, width: kScreenWidth, height: kScreenHeight - kNavHeight)
        scrollView.contentSize = scrollView.size
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalToSuperview().offset(AdaptSize(15))
            make.centerX.equalToSuperview()
        }
        byLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(15))
        }
        imageView.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(AdaptSize(120))
            make.top.equalTo(byLabel.snp.bottom).offset(AdaptSize(20))
        }
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(imageView.snp.bottom).offset(AdaptSize(20))
            make.bottom.equalToSuperview().offset(AdaptSize(-20))
        }
        registerButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(40)))
            make.bottom.equalToSuperview().offset(AdaptSize(-20) - kSafeBottomMargin)
            make.centerX.equalToSuperview()
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    @objc
    private func registerAction() {
        kWindow.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            kWindow.hideLoading()
            kWindow.toast("已报名，请等待对方审核")
            let vc = KFRegisterListViewController()
            self.navigationController?.push(vc: vc)
        }
    }
}
