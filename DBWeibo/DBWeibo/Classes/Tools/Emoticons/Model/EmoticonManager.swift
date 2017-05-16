//
//  EmoticonManager.swift
//
//  Created by zenghz on 2017/5/4.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class EmoticonManager {

    var packages: [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        // 1.添加最近表情的包
        packages.append(EmoticonPackage(id: ""))
        
        // 2.添加默认表情的包
        packages.append(EmoticonPackage(id: "com.sina.normal"))
        
        // 3.添加emoji表情的包
        packages.append(EmoticonPackage(id: "com.apple.emoji"))
    }
    
}
