//
//  WBWelcomeViewController.swift
//  DBWeibo
//
//  Created by zenghz on 2017/3/13.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit
import SDWebImage

class WBWelcomeViewController: UIViewController {

    // MARK: - 拖线的属性
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var welcomeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //??: 如果??前面的可选类型有值,那么将前面的可选类型进行解包并且赋值
        //  如果??前面的可选类型为nil,那么直接使用??后面的值
        //1.设置头像
        let prodileUrlString = WBUserAccountViewModel.shareInstance.account?.avatar_large
        if let url = URL(string: prodileUrlString ?? "") {
            
            iconView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "icon_user"))
        }

        //2.设置欢迎语句
        if let name = WBUserAccountViewModel.shareInstance.account?.screen_name {
            welcomeLbl.text = "Hi,\(name),欢迎回来"
        }
        
        //3.改变约束的值
        iconViewBottomCons.constant = UIScreen.main.bounds.height - 250
    
        //4.执行动画
        //Damping: 阻力系数,阻力系数越大,谭东的效果越不明显 0~1
        //initialSpringVelocity: 初始化速度
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5.0, options: [], animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (finished) in
           
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }

}





