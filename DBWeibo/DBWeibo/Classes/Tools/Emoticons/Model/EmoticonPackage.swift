//
//  EmoticonPackage.swift
//
//  Created by zenghz on 2017/5/4.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {

    @objc var emoticons: [Emoticon] = [Emoticon]()
    
    init(id: String) {
        super.init()
        
        // 1.最近分组
        if id == "" {
            
            addEmptyRmoticon(isRecently: true)
            return
        }
        
        // 2.根据id拼接info.plist路径
        let plistPath = Bundle.main.path(forResource: "\(id)/content.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        // 3.根据plist文件的路径读取数据
        guard let dict = NSDictionary(contentsOfFile: plistPath) else {
            return
        }
        
        guard let array = dict["emoticons"] as? [[String : String]] else {
            return
        }
        
        // 4.遍历数组
        var index = 0
        for var dict in array {
           
            if let png = dict["png"] {
               dict["png"] = id + "/" + png
            }
            
            let emoticon = Emoticon(dict: dict)
            emoticons.append(emoticon)
            
            index += 1
            
            if index == 20 {
                // 添加删除表情
                emoticons.append(Emoticon(isRemove: true))
                
                index = 0
            }
        }
        
        // 5.添加空白表情
        addEmptyRmoticon(isRecently: false)
    }
    
    private func addEmptyRmoticon(isRecently: Bool) {
    
        let count = emoticons.count % 21
        if count == 0 && !isRecently{
            return
        }
        
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        
        emoticons.append(Emoticon(isRemove: true))
    }

    
}
