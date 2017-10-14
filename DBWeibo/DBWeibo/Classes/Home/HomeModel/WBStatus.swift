//
//  WBStatus.swift
//  DBWeibo
//
//  Created by zenghz on 2017/3/15.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class WBStatus: NSObject {

    // MARK: - 属性
    /// 微博创建时间
    @objc var created_at: String?
    /// 微博来源
    @objc var source: String?
    /// 微博的正文
    @objc var text: String?
    /// 微博的ID
    @objc var mid: Int = 0
    /// 用户信息
    @objc var user: WBUser?
    /// 微博的配图
    @objc var pic_urls: [[String : String]]?

    /// 缩略图
    @objc var thumbnail_pic: String?
    /// 微博单张配图时候的中等质量的图
    @objc var bmiddle_pic: String?
    /// 原图
    @objc var original_pic: String?
    
    /// 微博对应的转发微博
    @objc var retweeted_status: WBStatus?
    
    // MARK: - 自定义构造函数
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
        
        // 1.将用户字典转成用户模型对象
        if let userDict = dict["user"] as? [String : AnyObject] {
            
            user = WBUser(dict: userDict)
        }
        
        // 2.将转发微博字典转成转发微博模型
        if let retweetedDict = dict["retweeted_status"] as?[String : AnyObject] {
            
            retweeted_status = WBStatus(dict: retweetedDict)
        }
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
