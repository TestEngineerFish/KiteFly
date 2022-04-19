//
//  BPChatRoomEmptyCell.swift
//  MessageCenter
//
//  Created by apple on 2021/11/20.
//  Copyright © 2021 KLC. All rights reserved.
//

import UIKit
import STYKit

class KFChatRoomEmptyCell: KFChatRoomBaseCell {
    
    private var emptyView: TYView_ty = {
        let view = TYView_ty()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.contentView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.selectionStyle  = .none
        self.backgroundColor = UIColor.clear
    }
    
    // MARK: ==== Event ====
}
