//
//  WBBaseViewController.swift
//  DBWeibo
//
//  Created by zenghz on 2017/2/16.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class WBBaseViewController: UITableViewController {

    //访客视图
    // MARK: - 懒加载属性
    var isLogin: Bool = WBUserAccountViewModel.shareInstance.isLogin
    
    lazy var visitorView: WBVisitorView = WBVisitorView.visitorView()
    
    // MARK: - 系统回调函数
    override func loadView() {
      
        //判断要加载哪一个View
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
    }
    
}

// MARK: - 设置UI界面
extension WBBaseViewController {
    /// 设置访客视图
    fileprivate func setupVisitorView() {
        
        view = visitorView
        
        //监听访客视图中 注册 和 登录 按钮的点击
        visitorView.registerBtn.addTarget(self, action: #selector(WBBaseViewController.registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(WBBaseViewController.loginBtnClick), for: .touchUpInside)
    }
    
    /// 设置导航栏左右的item
    fileprivate func setupNavigationItems() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(WBBaseViewController.registerBtnClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(WBBaseViewController.loginBtnClick))
    }
}

// MARK: - 事件监听
extension WBBaseViewController {
    /// 注册
    @objc fileprivate func registerBtnClick() {
        
        print(#function)
    }
    /// 登录
    @objc fileprivate func loginBtnClick() {
        
        //1.创建授权控制器
        let oauthVC = WBOAuthViewController()
        
        //2.包装导航控制器
        let oauthNav = UINavigationController(rootViewController: oauthVC)
        
        //3.弹出控制器
        present(oauthNav, animated: true, completion: nil)
    }
}
