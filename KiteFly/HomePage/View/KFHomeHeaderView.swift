//
//  KFHomeHeaderView.swift
//  KiteFly
//
//  Created by apple on 2022/4/1.
//

import Foundation
import TYCyclePagerView

class KFHomeHeaderView: BPView, TYCyclePagerViewDelegate, TYCyclePagerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let pageCellID  = "kKFHomeBannerCell"
    private let newsCellID  = "kKFHomeNewsItem"
    
    private var pageUrlList     = [KFHomePageModel]()
    private var newsModelList   = [KFNewsModel]()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.bindData()
        self.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(pageView)
        self.addSubview(pageControl)
        self.addSubview(collectionView)
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.pageView.register(KFHomePageCell.classForCoder(), forCellWithReuseIdentifier: pageCellID)
        self.collectionView.register(KFHomeNewsItem.classForCoder(), forCellWithReuseIdentifier: newsCellID)
        self.pageView.delegate         = self
        self.pageView.dataSource       = self
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
    }
    
    override func bindData() {
        super.bindData()
        self.pageUrlList   = BPFileManager.share.getJsonModelList(file: "PageUrl", type: KFHomePageModel.self) as? [KFHomePageModel] ?? []
        self.newsModelList = BPFileManager.share.getJsonModelList(file: "NewsModelList", type: KFNewsModel.self) as? [KFNewsModel] ?? []
        self.pageControl.numberOfPages = self.pageUrlList.count
        self.collectionView.reloadData()
    }
    
    override func updateConstraints() {
        pageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
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
            make.bottom.equalToSuperview()
        }
        super.updateConstraints()
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
        let model = self.pageUrlList[index]
        let vc = KFWebViewController()
        vc.urlStr = model.url
        vc.title  = "详情"
        UIViewController.currentNavigationController?.push(vc: vc)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.newsModelList[indexPath.row]
        let vc = KFNewsDetailViewController()
        vc.model = model
        UIViewController.currentNavigationController?.push(vc: vc)
    }
    
}

