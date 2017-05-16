//
//  FindEmoticon.swift
//
//  Created by zenghz on 2017/5/15.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {

    static let shared: FindEmoticon = FindEmoticon()
    
    // MARK: - 表情属性
    fileprivate lazy var manager: EmoticonManager = EmoticonManager()
    
    func findAttrString(statusText: String?, font: UIFont) -> NSMutableAttributedString? {
    
        // 0.空值校验
        guard let statusText = statusText else {
            return nil
        }
        
        // 1.创建匹配规则
        let pattern = "\\[.*?\\]"
        
        // 2.创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        // 3.开始匹配
        let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        
        // 4.获取结果
        let attrMStr = NSMutableAttributedString(string: statusText)
        for result in results.reversed() {
            
            // 4.1.获取chs
            let chs = (statusText as NSString).substring(with: result.range)
            
            // 4.2.根据chs,获取图片的路径
            guard let pngPath = findPngPath(chs: chs) else {
                return nil
            }
            
            // 4.3.创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            
            // 4.4.将属性字符串替换到
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
        }

        return attrMStr
    }
    
    private func findPngPath(chs: String) -> String? {
        
        for package in manager.packages{
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    
                    return emoticon.pngPath
                }
            }
        }
        
        return nil
    }
}
