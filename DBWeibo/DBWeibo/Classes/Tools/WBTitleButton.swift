//
//  WBTitleButton.swift
//  DBWeibo
//
//  Created by zenghz on 2017/2/17.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {

    // MARK: - 重写init函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(#imageLiteral(resourceName: "icon_arrow_up"), for: .normal)
        setImage(#imageLiteral(resourceName: "icon_arrow_down"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    
    //Swift 中规定: 重写控件的init(frame方法)或者init()方法,必须重写init?(coder aDecoder: NSCoder)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 5
    }

}
