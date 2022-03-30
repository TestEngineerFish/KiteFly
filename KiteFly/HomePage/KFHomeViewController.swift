//
//  KFHomeViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation

class KFHomeViewController: BPViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    private let newsCellID  = "kKFHomeNewsItem"
    private let noticCellID = "kKFHomeNoticCell"
    
    private var newsModelList   = [KFNewsModel]()
    private var noticeModelList = [KFNoticeModel]()
    
    private var bannerView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.randomColor()
        return view
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: AdaptSize(200), height: AdaptSize(100))
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
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
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bindData()
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(bannerView)
        self.view.addSubview(collectionView)
        self.view.addSubview(tableView)
        bannerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
            make.height.equalTo(AdaptSize(80))
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(bannerView.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(AdaptSize(120))
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "风筝"
        self.collectionView.register(KFHomeNewsItem.classForCoder(), forCellWithReuseIdentifier: newsCellID)
        self.tableView.register(KFHomeNoticCell.classForCoder(), forCellReuseIdentifier: noticCellID)
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.tableView.delegate        = self
        self.tableView.dataSource      = self
    }
    
    override func bindData() {
        super.bindData()
        self.newsModelList = BPFileManager.share.getJsonModelList(file: "NewsModelList", type: KFNewsModel.self) as? [KFNewsModel] ?? []
        self.noticeModelList = BPFileManager.share.getJsonModelList(file: "NoticModelList", type: KFNoticeModel.self) as? [KFNoticeModel] ?? []
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func updateUI() {
        super.updateUI()
        self.view.backgroundColor = .white
        
    }
    
    // MARK: ==== Event ====
    
    
    // MARK: ==== UICollectionViewDelegate, UICollectionViewDataSource ====
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newsModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellID, for: indexPath) as? KFHomeNewsItem else {
            return UICollectionViewCell()
        }
        let model = newsModelList[indexPath.row]
        item.setData(model: model)
        return item
    }
    
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticeModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: noticCellID) as? KFHomeNoticCell else {
            return UITableViewCell()
        }
        let model = noticeModelList[indexPath.row]
        cell.setData(model: model)
        return cell
    }
}
