//
//  Emoticon.swift
//
//  Created by zenghz on 2017/5/4.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class Emoticon: NSObject {

    // MARK: - 定义属性
    var code: String? {  // emoji的code
        didSet{
            guard let code = code else {
                return
            }
            
            // 1.创建扫描器
            let codeScanner = Scanner(string: code)
            
            // 2.扫描出code中的值
            var value: UInt32 = 0
            codeScanner.scanHexInt32(&value)
            
            // 3.将value转成字符
            let c = Character(UnicodeScalar(value)!)
            
            // 4.将字符转成字符串
            emojiCode = String(c)
        }
    }
    var png: String? {   // 普通表情对应的图片名字
        didSet{
            guard let png = png else {
                return
            }
            
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var chs: String?    // 普通表情对应的文字
    
    // MARK: - 数据处理
    var pngPath: String?
    var emojiCode: String?
    var isRemove: Bool = false
    var isEmpty: Bool = false
    
    // MARK: - 自定义构造函数
    init(dict: [String : String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    init(isRemove: Bool) {
        super.init()
        
        self.isRemove = isRemove
    }
    init(isEmpty: Bool) {
        super.init()
        
        self.isEmpty = isEmpty
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
    
        return dictionaryWithValues(forKeys: ["chs", "pngPath", "emojiCode"]).description
    }
}
