//
//  BPSystemAlbumListView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/11.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Photos
import UIKit

protocol BPSystemAlbumListViewDelegate: NSObjectProtocol {
    func selectedAlbum(model: BPPhotoAlbumModel?)
    func showAlbumAction()
    func hideAlbumAction()
}

class BPSystemAlbumListView: BPView, UITableViewDelegate, UITableViewDataSource {

    private let cellID = "kBPSystemAlbumCell"
    private var albumList: [BPPhotoAlbumModel] = []
    private var currentModel: BPPhotoAlbumModel? {
        didSet {
            self.delegate?.selectedAlbum(model: currentModel)
            self.tableView.reloadData()
        }
    }
    private var tableViewHeight = CGFloat.zero
    private let cellHeight      = AdaptSize(56)
    private let tableViewMaxH   = AdaptSize(600)

    weak var delegate: BPSystemAlbumListViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tableView: BPTableView = {
        let tableView = BPTableView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator   = false
        return tableView
    }()

    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.isUserInteractionEnabled = true
        return view
    }()

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(backgroundView)
        self.addSubview(tableView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.layer.masksToBounds  = true
        self.tableView.register(BPSystemAlbumCell.classForCoder(), forCellReuseIdentifier: cellID)
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(hideView))
        self.backgroundView.addGestureRecognizer(tapAction)
    }

    // MARK: ==== Event ====

    func setData(albumList: [BPPhotoAlbumModel], current model: BPPhotoAlbumModel?) {
        self.albumList    = albumList
        self.currentModel = model
        tableViewHeight   = CGFloat(albumList.count) * cellHeight
        tableViewHeight   = tableViewHeight > tableViewMaxH ? tableViewMaxH : tableViewHeight
        tableView.snp.remakeConstraints { (make) in
            make.center.width.equalToSuperview()
            make.bottom.equalTo(backgroundView.snp.top)
            make.height.equalTo(tableViewHeight)
        }
    }

    func showView() {
        self.isHidden = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.tableView.transform = CGAffineTransform(translationX: 0, y: self.tableViewHeight)
        } completion: { [weak self] finished in
            guard let self = self else { return }
            self.delegate?.showAlbumAction()
        }
    }

    @objc
    func hideView() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.tableView.transform = .identity
        } completion: { [weak self] (finished) in
            guard let self = self else { return }
            if finished {
                self.isHidden = true
                self.delegate?.hideAlbumAction()
            }
        }
    }

    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? BPSystemAlbumCell else {
            return UITableViewCell()
        }
        let model = self.albumList[indexPath.row]
        let selected: Bool = {
            guard let _currentModel = self.currentModel else { return false }
            return _currentModel.id == model.id
        }()
        cell.setData(model: model, isCurrent: selected)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentModel = self.albumList[indexPath.row]
        self.hideView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
