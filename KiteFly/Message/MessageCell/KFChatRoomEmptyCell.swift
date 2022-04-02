//
//  BPChatRoomEmptyCell.swift
//  MessageCenter
//
//  Created by apple on 2021/11/20.
//  Copyright © 2021 KLC. All rights reserved.
//

import UIKit


class KFChatRoomEmptyCell: KFChatRoomBaseCell {
    
    private var emptyView: KFView = {
        let view = KFView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.contentView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.selectionStyle  = .none
        self.backgroundColor = UIColor.clear
    }
    
    // MARK: ==== Event ====
}
