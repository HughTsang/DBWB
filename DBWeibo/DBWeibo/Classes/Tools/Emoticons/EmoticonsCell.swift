//
//  EmoticonsCell.swift
//
//  Created by zenghz on 2017/5/5.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class EmoticonsCell: UICollectionViewCell {
    
    // MARK: - 懒加载属性
    fileprivate lazy var emoticonBtn: UIButton = UIButton()
    
    // MARK: - 定义属性
    var emoticon: Emoticon? {
        didSet {
            guard let emoticon = emoticon else {
                return
            }
            
            // 1.设置emoticonBtn的内容
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            
            // 2.设置删除按钮
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    // MARK: - 系统回调函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI界面
extension EmoticonsCell {
    
    fileprivate func setupUI() {
        
        contentView.addSubview(emoticonBtn)
        emoticonBtn.frame = contentView.bounds
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
