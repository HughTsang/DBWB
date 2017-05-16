//
//  WBComposeTextView.swift
//  DBWeibo
//
//  Created by zenghz on 2017/5/4.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit
import SnapKit

class WBComposeTextView: UITextView {

    // MARK: - 懒加载
    lazy var placeHolderLbl: UILabel = UILabel()
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 添加子控件
        setupUI()
    }
    
    // 对子控件进行初始化操作(约束,颜色...)
    override func awakeFromNib() {}
}

// MARK: - 设置UI
extension WBComposeTextView {

    fileprivate func setupUI() {
        
        // 1.添加子控件
        addSubview(placeHolderLbl)
        
        // 2.设置frame
        placeHolderLbl.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(8)
        }
        
        // 3.设置placeHoderLbl属性
        placeHolderLbl.textColor = UIColor.lightGray
        placeHolderLbl.font = font
        placeHolderLbl.text = "分享新鲜事..."
        
        // 4.设置内容的内边距
        textContainerInset = UIEdgeInsetsMake(5, 8, 5, 8)
    }
}
