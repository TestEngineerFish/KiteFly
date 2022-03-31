//
//  BPAlertViewTwoButton.swift
//  Tenant
//
//  Created by samsha on 2021/3/19.
//

import UIKit

public class BPAlertViewTwoButton: BPBaseAlertView {
    
    
    public init(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?, isDestruct: Bool = false) {
        super.init(frame: .zero)
        self.isDestruct            = isDestruct
        self.titleLabel.text       = title
        self.descriptionLabel.text = description
        self.rightActionBlock      = rightBtnClosure
        self.leftActionBlock       = leftBtnClosure
        self.leftButton.setTitle(leftBtnName, for: .normal)
        self.rightButton.setTitle(rightBtnName, for: .normal)
        self.createSubviews()
        self.bindProperty()
    }
    public init(title: String?, description: NSMutableAttributedString, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?, isDestruct: Bool = false) {
        super.init(frame: .zero)
        self.isDestruct                         = isDestruct
        self.titleLabel.text                    = title
        self.descriptionLabel.attributedText    = description
        self.rightActionBlock                   = rightBtnClosure
        self.leftActionBlock                    = leftBtnClosure
        self.leftButton.setTitle(leftBtnName, for: .normal)
        self.rightButton.setTitle(rightBtnName, for: .normal)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        
        mainView.addSubview(titleLabel)
        mainView.addSubview(contentScrollView)
        contentScrollView.addSubview(descriptionLabel)
        mainView.addSubview(leftButton)
        mainView.addSubview(rightButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topPadding)
            make.left.equalToSuperview().offset(leftPadding)
            make.right.equalToSuperview().offset(-rightPadding)
            make.height.equalTo(titleHeight)
        }
        mainViewHeight += topPadding + titleHeight
        let descriptionLabelW = mainViewWidth - leftPadding - rightPadding
        let descriptionLabelH = descriptionLabel.text?.textHeight(font: descriptionLabel.font, width: descriptionLabelW) ?? 0
        descriptionLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: descriptionLabelW, height: descriptionLabelH))
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(leftPadding)
            make.right.equalToSuperview().offset(-rightPadding)
        }
        contentScrollView.contentSize = CGSize(width: descriptionLabelW, height: descriptionLabelH)
        contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(defaultSpace)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(rightButton.snp.top).offset(-defaultSpace)
        }
        if descriptionLabelH > maxContentHeight {
            mainViewHeight += defaultSpace + maxContentHeight
        } else {
            mainViewHeight += defaultSpace + descriptionLabelH
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-30))
            make.size.equalTo(rightButton.size)
            make.bottom.equalToSuperview().offset(-bottomPadding)
        }
        leftButton.snp.makeConstraints { (make) in
            make.bottom.size.equalTo(rightButton)
            make.left.equalToSuperview().offset(AdaptSize(30))
        }
        mainViewHeight += defaultSpace + rightButton.height + bottomPadding
        
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(mainViewWidth)
            make.height.equalTo(mainViewHeight)
        }
    }
    
    public override func bindProperty() {
        super.bindProperty()
        self.backgroundView.isUserInteractionEnabled = false
    }
}
