//
//  KFNewsDetailViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation

class KFNewsDetailViewController: KFViewController {
    
    var model: KFNewsModel?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator   = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private var titleLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptSize(20))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private var timeLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .right
        return label
    }()
    private var imageView: KFImageView = {
        let imageView = KFImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius  = AdaptSize(10)
        return imageView
    }()
    private var contentLabel: KFLabel = {
        let label = KFLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindData()
        self.createSubviews()
        self.bindProperty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KFChatRequestManager.share.requestRecord(content: "主页首页 -- 新闻详情")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(imageView)
        scrollView.addSubview(contentLabel)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title      = "详情"
        self.customNavigationBar?.rightTitle = "收藏"
    }
    
    override func rightAction() {
        super.rightAction()
        self.view.toast("收藏成功")
    }
    
    override func bindData() {
        super.bindData()
        guard let model = self.model else {
            return
        }
        self.titleLabel.text   = model.title
        self.timeLabel.text    = model.time?.timeStr()
        self.contentLabel.text = model.content
        self.imageView.setImage(with: model.icon)
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
        timeLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(5))
            make.height.equalTo(timeLabel.font.lineHeight)
        }
        imageView.snp.makeConstraints { make in
            make.width.equalTo(kScreenWidth - AdaptSize(30))
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(AdaptSize(20))
            make.height.equalTo(AdaptSize(120))
        }
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(AdaptSize(20))
            make.bottom.equalToSuperview().offset(AdaptSize(-20))
        }
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    
}
