//
//  WBOAuthViewController.swift
//  DBWeibo
//
//  Created by zenghz on 2017/3/13.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBOAuthViewController: UIViewController {

    // MARK: - 控件属性
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置导航栏内容
        setupNavigationBar()
        
        // 2.加载网页
        loadPage()
    }

}

// MARK: - 设置UI界面相关
extension WBOAuthViewController {

    fileprivate func setupNavigationBar() {
        
        // 1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(WBOAuthViewController.closeItemClick))
        
        // 2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(WBOAuthViewController.fillItemClick))
        
        // 3.设置标题
        navigationItem.title = "登录"
    }
    
    fileprivate func loadPage() {
        
        // 1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        // 2.创建对应的URL
        guard let url = URL(string: urlString) else {
            return
        }
        
        // 3.创建URLRequest对象
        let request = URLRequest(url: url)
        
        // 4.加载URLRequest
        webView.loadRequest(request)
    }
    
}

// MARK: - 事件监听函数
extension WBOAuthViewController {

    @objc fileprivate func closeItemClick() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func fillItemClick() {
        
// TODO: 在这里设置默认的账号密码,在登录页面使用"填充"按钮可使用
        // 0.设置默认账号和密码
        let account = ""
        let pwd = ""
        if account == "" || pwd == ""{
            SVProgressHUD.showError(withStatus: "你还没设置默认账号和密码~手动填写吧~~~")
            return
        }
        
        // 1.js代码
        let jsCode = "document.getElementById('userId').value='\(account)';document.getElementById('passwd').value='\(pwd)';"
       
        // 2.执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}

// MARK: - UIWebViewDelegate
extension WBOAuthViewController: UIWebViewDelegate {
    
    
    /// webView开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        SVProgressHUD.show()
    }
    
    /// webView网页加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
    
    /// webView网页加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        SVProgressHUD.dismiss()
    }
    
    /// 当准备加载某一个页面时,会执行该方法
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.获取加载网页的URL
        guard let url = request.url else {
            return true
        }
        
        // 2.获取url中的字符串
        let urlString = url.absoluteString

        // 3.判断该字符串中是否包含code
        // http://www.baidu.com/?code=9a0f7209e362b1f30056d74bdb790c4d
        guard urlString.contains("code=") else {
            return true
        }
        
        // 4.将code截取出来
        let code = urlString.components(separatedBy: "code=").last!
        
        // 5.请求accessToken
        loadAccessToken(code: code)
        
        return false
    }
    
}

// MARK: - 请求数据
extension WBOAuthViewController {
    
    /// 请求AccessToken
    fileprivate func loadAccessToken(code: String) {
        WBNetworkTools.shareInstance.loadAccessToken(code: code) { (result, error) in
            
            // 1.错误校验
            if error != nil {
                print(error!)
                return
            }
            
            // 2.拿到结果
            guard let accountDict = result else {
                print("没有获取到授权后的数据")
                return
            }
            
            // 3.将字典转成模型对象
            let account = WBUserAccount(dict: accountDict)
            
            // 4.请求用户信息
            self.loadUserInfo(account: account)
        }
    }
    
    
    fileprivate func loadUserInfo(account: WBUserAccount) {
        
        WBNetworkTools.shareInstance.loadUserInfo(account: account) { (result, error) in
            
            // 1.错误校验
            if error != nil {
                print(error ?? "没有错误信息")
                return
            }
            
            // 2.拿到用户信息结果
            //avatar_large
            //screen_name
            guard let userInfoDict = result else {
                return
            }
            
            // 3.从字典中取出昵称和用户头像地址
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            // 4.将account对象保存
            NSKeyedArchiver.archiveRootObject(account, toFile: WBUserAccountViewModel.shareInstance.accountPath)
         
            // 5.将account对象设置到单例对象中
            WBUserAccountViewModel.shareInstance.account = account
            
            // 6.退出当前控制器
            self.dismiss(animated: false, completion: {
                
                // 7.显示欢迎界面
                UIApplication.shared.keyWindow?.rootViewController = WBWelcomeViewController()
            })
        }
    }
}


