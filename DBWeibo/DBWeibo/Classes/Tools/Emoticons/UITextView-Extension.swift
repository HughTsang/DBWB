//
//  UITextView-Extension.swift
//
//  Created by zenghz on 2017/5/5.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

extension UITextView {
    
    /// 给textView插入表情
    func insertEmoticon(emoticon: Emoticon) -> () {
        
        // 1.删除按钮
        if emoticon.isRemove {
            
            deleteBackward()
            return
        }
        
        // 2.emoji表情
        if emoticon.emojiCode != nil {
            // 2.1.方法一
            insertText(emoticon.emojiCode!)
            
            // 2.2.方法二
            //            let textRange = textView.selectedTextRange!
            //            textView.replace(textRange, withText: emoticon.emojiCode!)
            
            return
        }
        
        // 3.普通表情: 图文混排
        // 3.1.根据图片路径创建属性字符串
        let attachment = EmoticonAttachment()
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        attachment.chs = emoticon.chs
        
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        // 4.2.创建可变的属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        // 4.3.将图片属性字符串,替换到可变属性字符串的某一个位置
        // 4.3.1.获取光标所在的位置
        let range = selectedRange
        // 4.3.2.替换属性字符串
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        
        // 5.显示属性字符串
        attributedText = attrMStr
        
        // 6.将文字的大小重置回去
        self.font = font
        
        // 7.将光标设置回原来位置 + 1
        selectedRange = NSMakeRange(range.location + 1, 0)
    }
    
    /// 获取textView属性字符串,对应的表情字符串
    func getEmoticonString() -> String {
        
        // 1.获取属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        // 2.遍历属性字符串
        let range = NSMakeRange(0, attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            
            if let attachment = dict[NSAttributedStringKey.attachment] as? EmoticonAttachment {
                
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        
        return attrMStr.string
    }
}
