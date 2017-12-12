//
//  Common.swift
//  DBWeibo
//
//  Created by zenghz on 2017/3/13.
//  Copyright © 2017年 Personal. All rights reserved.
//

import Foundation
import UIKit

// TODO: 在这里设置自己的应用授权App Key 和 App Secret

// MARK: - 授权的常量
let app_key = "1571606491"
let app_secret = "692b9cca4bdbb2ffc4cc9349869f5011"
let redirect_uri = "http://www.baidu.com"

// MARK: - UI相关
let kGap = 10
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let kNavBarHeight = UIApplication.shared.statusBarFrame.height + 44
var kTabBarHeight = 49

// MARK: - 选择照片的通知常量
let PicPickerAddPhotoNoti = "PicPickerAddPhotoNoti"
let PicPickerRemovePhotoNoti = "PicPickerRemovePhotoNoti"

// MARK: - 照片浏览器的通知常量
let ShowPhotoBrowserNoti = "ShowPhotoBrowserNoti"
let ShowPhotoBrowserIndexKey = "ShowPhotoBrowserIndexKey"
let ShowPhotoBrowserUrlsKey = "ShowPhotoBrowserUrlsKey"
