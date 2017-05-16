//
//  WBProfileViewController.swift
//  DBWeibo
//
//  Created by zenghz on 2017/2/16.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class WBProfileViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.setupVisitorViewInfo(iconName: "profile_400*400", title: "登录后,你的微博,相册,个人资料会显示在这里,展示给别人")
    }

}
