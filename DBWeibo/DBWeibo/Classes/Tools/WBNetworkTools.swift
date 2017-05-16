//
//  WBNetworkTools.swift
//  DBWeibo
//
//  Created by zenghz on 2017/2/21.
//  Copyright © 2017年 Personal. All rights reserved.
//

import AFNetworking
import SVProgressHUD

//定义枚举类型
/// 请求方式
///
/// - get: GET请求
/// - post: POST请求
enum RequestType: String {
    case get    = "GET"
    case post   = "POST"
}

class WBNetworkTools: AFHTTPSessionManager {

    //let 是线程安全的
    static let shareInstance: WBNetworkTools = {
    
        let tools = WBNetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")

        return tools
    }()
}

// MARK: - 封装请求方法
extension WBNetworkTools {
    
    func request(requestType: RequestType, urlString: String, parameters: [String : Any], finished: @escaping ((_ result: Any?, _ error: Error?) -> ())) {
        
        SVProgressHUD.show()
        //1.定义成功的回调闭包
        let successCallBack = { (task: URLSessionDataTask, result: Any?) in
            
            SVProgressHUD.dismiss()
            
            finished(result, nil)
        }
        
        //2.定义失败的回调闭包
        let failureCallBack = { (task: URLSessionDataTask?, error: Error) in
            
            SVProgressHUD.dismiss()
            
            finished(nil, error)
        }

        //3.发送网络请求
        if requestType == .get {
            
            get(urlString, parameters: parameters, progress: nil
                , success: successCallBack, failure: failureCallBack)
        }
        else if requestType == .post {
        
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
        
    }
}

// MARK: - 请求AccessToken
extension WBNetworkTools {

    func loadAccessToken(code: String, finished: @escaping (_ result: [String : Any]?, _ error: Error?) -> ()) {
        
        //1.获取请求的urlstring
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        //2.获取请求参数
        let parameters = ["client_id" : app_key,
                          "client_secret" : app_secret,
                          "grant_type" : "authorization_code",
                          "redirect_uri" : redirect_uri,
                          "code" : code,]
        
        //3.发送网络请求
        request(requestType: .post, urlString: urlString, parameters: parameters) { (result, error) in
            
            finished(result as? [String : Any], error)
        }
        
    }
}

// MARK: - 请求用户的信息
extension WBNetworkTools {
    
    func loadUserInfo(account: WBUserAccount, finished: @escaping (_ result: [String : Any]?, _ error: Error?) -> ()) -> () {
        
        //1.获取请求URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        //2.获取请求参数
        let parameters = ["access_token" : account.access_token, "uid" : account.uid]
        
        //3.发送网络请求
        request(requestType: .get, urlString: urlString, parameters: parameters) { (result, error) in
            
            finished(result as? [String : Any], error)
        }
    }
}

// MARK: - 请求首页微博数据
extension WBNetworkTools {

    func loadStatuses(since_id: Int, max_id: Int, finished: @escaping (_ result: [[String : AnyObject]]?, _ error: Error?) -> ()) {
        //1.获取请求URLString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        //2.获取请求参数
        let accessToken = (WBUserAccountViewModel.shareInstance.account?.access_token)!
        let parameters = ["access_token" : accessToken, "since_id" : since_id, "max_id" : max_id] as [String : Any]
        
        //3.发送网络请求
        request(requestType: .get, urlString: urlString, parameters: parameters) { (result, error) in
            
            //1.获取字典的数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            
            //2.将数组数据回调给外界控制器
            finished(resultDict["statuses"] as? [[String : AnyObject]], error)
        }
    }
}

// MARK: - 发布微博(带图片和不带图片)
extension WBNetworkTools {

    func sendStatus(statusText: String, isSuccess: @escaping (_ isSuccess: Bool) -> ()) {
    
        let urlStr = "https://api.weibo.com/2/statuses/update.json"
        
        let accessToken = (WBUserAccountViewModel.shareInstance.account?.access_token)!
        let parameters = ["access_token" : accessToken, "status" : statusText]
        
        request(requestType: .post, urlString: urlStr, parameters: parameters) { (result, error) in
            
            if result != nil{
                isSuccess(true)
            } else {
                isSuccess(false)
            }
        }
    }
    
    func sendStatus(statusText: String, image: UIImage, isSuccess: @escaping (_ isSuccess: Bool) -> ()) {
    
        let urlStr = "https://api.weibo.com/2/statuses/upload.json"
        
        let accessToken = (WBUserAccountViewModel.shareInstance.account?.access_token)!
        let parameters = ["access_token" : accessToken, "status" : statusText]
        
        post(urlStr, parameters: parameters, constructingBodyWith: { (formData) in
            
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                formData.appendPart(withFileData: imageData, name: "pic", fileName: "hz", mimeType: "image/png")
            }
        }, progress: nil, success: { (_, _) in
            
            isSuccess(true)
            
        }) { (_, error) in
            
            print("error = \(error)")
        }
    }
    
}






