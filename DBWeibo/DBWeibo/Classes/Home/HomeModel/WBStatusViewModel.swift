//
//  WBStatusViewModel.swift
//  DBWeibo
//
//  Created by zenghz on 2017/4/26.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class WBStatusViewModel: NSObject {

    // MARK: - 定义属性
    @objc var status: WBStatus?
    
    @objc var cellHeight: CGFloat = 0
    
    // MARK: - 对数据处理的属性
    /// 微博来源处理之后的数据
    @objc var sourceText: String?
    /// 微博创建时间处理之后的数据
    @objc var createdAtText: String?
    
    /// 处理用户认证图标
    @objc var verifiedImage: UIImage?
    /// 处理用户会员等级图标
    @objc var vipImage: UIImage?
    /// 处理用户头像的地址
    @objc var profileURL: URL?
    /// 处理微博配图的数据
    @objc var picURLs: [URL] = [URL]()
    
    // MARK: - 自定义构造函数
    init(status: WBStatus) {
        self.status = status
        
        // 1.对来源处理
        if let source = status.source, source != "" {
            // 1.2.对来源的字符串进行处理
            //<a href=\"http://app.weibo.com/t/feed/6e3owN\" rel=\"nofollow\">iPhone 7 Plus</a>
            // 1.2.1.获取起始位置和截取的长度
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "<", options: NSString.CompareOptions.backwards).location - startIndex
            
            // 1.2.2.截取字符串
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        
        // 2.处理时间
        if let createAt = status.created_at, createAt != "" {
            
            createdAtText = Date.createDateString(createAtStr: createAt)
        }
        
        // 3.处理认证图标
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:// 微博认证用户
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:// 微博企业认证
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:// 微博达人
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        // 4.处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        // 5.处理用户头像的地址
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = URL(string: profileURLString)
        
        // 6.处理微博配图的数据
        let picURLDicts = status.pic_urls?.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picURLDicts = picURLDicts {
            
            for picURLDict in picURLDicts {
                
                guard let picURLString = picURLDict["thumbnail_pic"] else {
                    continue
                }
                
                guard let picURL = URL(string: picURLString) else {
                    continue
                }
                
                picURLs.append(picURL)
            }
        }
    }
}
