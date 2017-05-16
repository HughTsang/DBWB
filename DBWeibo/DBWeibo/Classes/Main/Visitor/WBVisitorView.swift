//
//  WBVisitorView.swift
//  DBWeibo
//
//  Created by zenghz on 2017/2/17.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class WBVisitorView: UIView {

    // MARK: - 提供快速通过XIB创建的类方法
    class func visitorView() -> WBVisitorView {
        
        return Bundle.main.loadNibNamed("WBVisitorView", owner: nil, options: nil)?.first as! WBVisitorView
    }
    
    // MARK: - 控件的属性
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    // MARK: - 自定义函数
    func setupVisitorViewInfo(iconName: String, title: String) {
    
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotationView.isHidden = true
    }
    
    func addRotationAnimation() {
        
//        CAKeyframeAnimation
//        let keyFrameAnimation = CAKeyframeAnimation()
//        keyFrameAnimation.values =
        
//        CABasicAnimation
        //1.创建动画
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    
        //2.设置动画属性
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.duration = 2
        rotationAnimation.isRemovedOnCompletion = false

        //3.将动画添加到layer中
        rotationView.layer.add(rotationAnimation, forKey: nil)
    }
    

}
