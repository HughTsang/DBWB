//
//  WBUserAccountTool.swift
//  DBWeibo
//
//  Created by zenghz on 2017/3/13.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class WBUserAccountViewModel {
    
    // MARK: - 将类设计成单例
    static let shareInstance: WBUserAccountViewModel = WBUserAccountViewModel()
    
    // MARK: - 定义属性
    var account: WBUserAccount?
    

    // MARK: - 计算属性
    var accountPath: String {
     
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).strings(byAppendingPaths: ["account.plist"]).first!
    }
    
    var isLogin: Bool {
    
        if account == nil {
            return false
        }
        
        guard let expiresDate = account?.expires_date else {
            return false
        }
        
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    
    // MARK: 重写init()函数
    init() {
        
        //1.从沙盒中读取归档的信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? WBUserAccount
    }
}
