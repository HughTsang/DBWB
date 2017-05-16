//
//  WBPresentationController.swift
//  DBWeibo
//
//  Created by zenghz on 2017/2/17.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class WBPresentationController: UIPresentationController {

    // MARK: - 对外提供属性
    var presentedFrame: CGRect = CGRect.zero
    
    
    // MARK: - 懒加载属性
    fileprivate lazy var coverView: UIView = UIView()
    
    // MARK: - 系统回调函数
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        //1.设置弹出View的尺寸
        presentedView?.frame = presentedFrame
        
        //2.添加蒙版
        setupCoverView()
    }
    
    
}

// MARK: - 设置UI界面相关
extension WBPresentationController {
    
    fileprivate func setupCoverView() {
        
        //1.添加蒙版
        containerView?.insertSubview(coverView, belowSubview: presentedView!)
        
        //2.设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        
        //3.添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(WBPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tap)
    }
}

// MARK: - 事件监听
extension WBPresentationController {
    
    @objc fileprivate func coverViewClick() {
        
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}






