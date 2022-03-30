//
//  KFHomeViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation
import TYCyclePagerView

class KFHomeViewController: BPViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {
    
    private let pageCellID  = "kKFHomeBannerCell"
    private let newsCellID  = "kKFHomeNewsItem"
    private let noticCellID = "kKFHomeNoticCell"
    
    private var pageUrlList     = [KFHomePageModel]()
    private var newsModelList   = [KFNewsModel]()
    private var noticeModelList = [KFNoticeModel]()
    
    private var pageView: TYCyclePagerView = {
        let pageView = TYCyclePagerView()
        pageView.backgroundColor = .clear
        pageView.autoScrollInterval = 3
        return pageView
    }()
    private var pageControl: TYPageControl = {
        let control = TYPageControl()
        control.currentPageIndicatorSize = CGSize(width: AdaptSize(5), height: AdaptSize(5))
        control.pageIndicatorSize = CGSize(width: AdaptSize(5), height: AdaptSize(5))
        control.currentPageIndicatorTintColor = UIColor.white
        control.pageIndicatorTintColor = UIColor.hex(0xffffff).withAlphaComponent(0.5)
        return control
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
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(pageView)
        self.view.addSubview(pageControl)
        self.view.addSubview(collectionView)
        self.view.addSubview(tableView)
        pageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
            make.height.equalTo(AdaptSize(120))
        }
        pageControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(pageView).offset(AdaptSize(-5))
            make.height.equalTo(AdaptSize(10))
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(pageView.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(AdaptSize(100))
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "风筝"
        self.pageView.register(KFHomePageCell.classForCoder(), forCellWithReuseIdentifier: pageCellID)
        self.collectionView.register(KFHomeNewsItem.classForCoder(), forCellWithReuseIdentifier: newsCellID)
        self.tableView.register(KFHomeNoticCell.classForCoder(), forCellReuseIdentifier: noticCellID)
        self.pageView.delegate         = self
        self.pageView.dataSource       = self
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.tableView.delegate        = self
        self.tableView.dataSource      = self
    }
    
    override func bindData() {
        super.bindData()
        self.pageUrlList   = BPFileManager.share.getJsonModelList(file: "PageUrl", type: KFHomePageModel.self) as? [KFHomePageModel] ?? []
        self.newsModelList = BPFileManager.share.getJsonModelList(file: "NewsModelList", type: KFNewsModel.self) as? [KFNewsModel] ?? []
        self.noticeModelList = BPFileManager.share.getJsonModelList(file: "NoticModelList", type: KFNoticeModel.self) as? [KFNoticeModel] ?? []
        self.pageControl.numberOfPages = self.pageUrlList.count
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
    
    // MARK: ==== TYCyclePagerViewDelegate, TYCyclePagerViewDataSource ====
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: kScreenWidth, height: AdaptSize(120))
        layout.itemSpacing = .zero
        return layout
    }
    
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return 3
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: pageCellID, for: index) as? KFHomePageCell else {
            return UICollectionViewCell()
        }
        let model = self.pageUrlList[index]
        cell.setData(model: model)
        return cell
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        self.pageControl.currentPage = toIndex
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didSelectedItemCell cell: UICollectionViewCell, at index: Int) {
        print("click \(index)")
    }
    
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
