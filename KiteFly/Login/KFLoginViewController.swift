//
//  KFLoginViewController.swift
//  KiteFly
//
//  Created by apple on 2022/3/30.
//

import Foundation

class KFLoginViewController: BPViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }
    
    override func createSubviews() {
        super.createSubviews()
        
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "登录"
    }
    
    override func bindData() {
        super.bindData()
    }
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
    }
    
    // MARK: ==== Event ====
    
}
