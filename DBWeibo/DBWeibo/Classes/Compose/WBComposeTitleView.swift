//
//  WBComposeTitleView.swift
//  DBWeibo
//
//  Created by zenghz on 2017/5/4.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit
import SnapKit

class WBComposeTitleView: UIView {

    // MARK: - 懒加载属性
    fileprivate lazy var titleLbl: UILabel = UILabel()
    fileprivate lazy var screenNameLbl: UILabel = UILabel()
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) has not be implemented")
    }
}

extension WBComposeTitleView {

    fileprivate func setupUI() {
    
        // 1.添加子控件
        addSubview(titleLbl)
        addSubview(screenNameLbl)
        
        // 2.设置frame
        titleLbl.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLbl.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(titleLbl.snp.centerX)
            make.top.equalTo(titleLbl.snp.bottom).offset(3)
        }
        
        // 3.设置控件属性
        titleLbl.font = UIFont.systemFont(ofSize: 16)
        screenNameLbl.font = UIFont.systemFont(ofSize: 14)
        screenNameLbl.textColor = UIColor.lightGray
        
        titleLbl.text = "发微博"
        screenNameLbl.text = WBUserAccountViewModel.shareInstance.account?.screen_name
    }
}

















