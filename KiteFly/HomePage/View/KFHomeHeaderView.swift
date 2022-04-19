//
//  KFHomeHeaderView.swift
//  KiteFly
//
//  Created by apple on 2022/4/1.
//

import Foundation
import TYCyclePagerView
import STYKit

class KFHomeHeaderView: TYView_ty, TYCyclePagerViewDelegate, TYCyclePagerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        control.currentPageIndicatorSize = CGSize(width: AdaptSize_ty(5), height: AdaptSize_ty(5))
        control.pageIndicatorSize = CGSize(width: AdaptSize_ty(5), height: AdaptSize_ty(5))
        control.currentPageIndicatorTintColor = UIColor.white
        control.pageIndicatorTintColor = UIColor.hex_ty(0xffffff).withAlphaComponent(0.5)
        return control
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: AdaptSize_ty(200), height: AdaptSize_ty(100))
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.bindData_ty()
        self.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(pageView)
        self.addSubview(pageControl)
        self.addSubview(collectionView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.pageView.register(KFHomePageCell.classForCoder(), forCellWithReuseIdentifier: pageCellID)
        self.collectionView.register(KFHomeNewsItem.classForCoder(), forCellWithReuseIdentifier: newsCellID)
        self.pageView.delegate         = self
        self.pageView.dataSource       = self
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
    }
    
    override func bindData_ty() {
        super.bindData_ty()
        self.pageUrlList   = TYFileManager_ty.share_ty.getJsonModelList_ty(file_ty: "PageUrl", type_ty: KFHomePageModel.self) as? [KFHomePageModel] ?? []
        self.newsModelList = TYFileManager_ty.share_ty.getJsonModelList_ty(file_ty: "NewsModelList", type_ty: KFNewsModel.self) as? [KFNewsModel] ?? []
        self.pageControl.numberOfPages = self.pageUrlList.count
        self.collectionView.reloadData()
    }
    
    override func updateConstraints() {
        pageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(AdaptSize_ty(120))
        }
        pageControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(pageView).offset(AdaptSize_ty(-5))
            make.height.equalTo(AdaptSize_ty(10))
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(pageView.snp.bottom).offset(AdaptSize_ty(10))
            make.height.equalTo(AdaptSize_ty(100))
            make.bottom.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    
    // MARK: ==== TYCyclePagerViewDelegate, TYCyclePagerViewDataSource ====
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: kScreenWidth_ty, height: AdaptSize_ty(120))
        layout.itemSpacing = .zero
        return layout
    }
    
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return self.pageUrlList.count
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
        currentNVC_ty?.push_ty(vc_ty: vc)
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
        currentNVC_ty?.push_ty(vc_ty: vc)
    }
    
}

