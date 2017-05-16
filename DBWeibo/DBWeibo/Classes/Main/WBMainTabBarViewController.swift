//
//  WBMainTabBarViewController.swift
//  DBWeibo
//
//  Created by zenghz on 2017/2/16.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class WBMainTabBarViewController: UITabBarController {

    /*
     现在的访问权限则依次为：open，public，internal，fileprivate，private。
     
     fileprivate: 这个元素的访问权限为文件内私有。过去的private对应现在的fileprivate
     private: 现在的private则是真正的私有，离开了这个类或者结构体的作用域外面就无法访问
     open: open则是弥补public语义上的不足。
        现在的pubic有两层含义：
        这个元素可以在其他作用域被访问
        这个元素可以在其他作用域被继承或者override
    */
    // MARK: - 懒加载属性
    fileprivate lazy var composeBtn = UIButton(imageName: "", bgImageName: "compose_product_plus")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         //通过代码创建
//        setupChildVCWayOne()
         //通过JSON创建
//        setupChildVCWayTwo()
         */
        
        setupComposeBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setupTabBarItems()
    }

}

// MARK: - 设置UI界面
extension WBMainTabBarViewController {
    
    /// 设置发布按钮
    fileprivate func setupComposeBtn() {
        
        tabBar.addSubview(composeBtn)
        
        //设置位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
        //监听点击
        //Selector两种写法
        //1>Selector("方法名")
        //2>"方法名"
//        composeBtn.addTarget(self, action: Selector("composeClicked"), for: .touchUpInside)
        composeBtn.addTarget(self, action: #selector(WBMainTabBarViewController.composeClicked), for: .touchUpInside)
    }
    
    /// 调整tabbar中item
    fileprivate func setupTabBarItems() {
        
        //1.遍历所有的item
        guard let count = tabBar.items?.count else {
            return
        }
        
        for i in 0..<count {
            
            //2.获取item
            let item = tabBar.items![i]
            
            //3.如果下标是2,则该item不可以和用户交互
            item.isEnabled = i == 2 ? false : true
        }
    }

}

// MARK: - 事件监听
extension WBMainTabBarViewController {
    
    //事件监听本质发送消息,但是发送消息是OC的特性
    //将方法包装成@SEL --> 类中查找方法列表 --> 根据@SEL找到imp指针(函数指针) --> 执行函数
    //如果Swift中将一个函数声明成fileprivate,那么该函数不会被添加到方法列表中
    //如果在fileprivate前面加上@objc,那么该方法依然会被添加到方法列表中
    
    /// 监听发布按钮点击
    @objc fileprivate func composeClicked() {
        
        // 1.创建发布控制器
        let composeVc = WBComposeViewController()
        let composeNav = UINavigationController(rootViewController: composeVc)
        present(composeNav, animated: true, completion: nil)
    }
}

// MARK: - 通过纯代码创建
extension WBMainTabBarViewController {

    func setupChildVCWayOne() {
        
        addChildViewController("WBHomeViewController", title: "首页", imageName: "tabbar_home", selectedImageName: "tabbar_home_selected")
        addChildViewController("WBMessageViewController", title: "消息", imageName: "tabbar_message_center", selectedImageName: "tabbar_message_center_selected")
        addChildViewController("WBDiscoverViewController", title: "发现", imageName: "tabbar_discover", selectedImageName: "tabbar_discover_selected")
        addChildViewController("WBProfileViewController", title: "我", imageName: "tabbar_profile", selectedImageName: "tabbar_profile_selected")
    }
    
    func setupChildVCWayTwo() {
        
        // 1.获取文件路径
        guard let jsonPath = Bundle.main.path(forResource: "mainTabBar.json", ofType: nil) else {
            return
        }
        // 2.通过文件路径创建NSData
        guard let jsonData = NSData(contentsOfFile: jsonPath) else {
            return
        }
        
        // 带throws的方法需要抛异常
        /*
         * 有可能发生异常的代码放在这
         */
        // 3.序列化 data -> array
        /*
         * try 和 try! 的区别
         * try 发生异常会跳到catch代码中
         * try! 发生异常程序会直接crash
         *  try? 告诉系统可能有错, 也可能没错, 如果发生错误, 那么返回nil, 如果没有发生错误, 会见数据包装成一个可选类型的值返回给我们
         */
        /*
         方式一: try
         do {
         
            let dictArr = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
            }
            
            //其它代码
         
         }catch {
            // error: 异常对象
            print(error)
         }
         
         //方式二: try! 发生异常程序会直接crash 不建议使用
         let dictArr = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
         
         */
        //方式三: 常用方式 try? 告诉系统可能有错, 也可能没错, 如果发生错误, 那么返回nil, 如果没有发生错误, 会见数据包装成一个可选类型的值返回给我们
        guard let dictArr = try? JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
            return
        }
        // 4.遍历数组
        // 在Swift中遍历数组，必须明确数据的类型 [[String: String]]表示字典里键值都是字符串 [[String]]表示数组里都是字符串
        for dict in dictArr as! [[String: String]] {
            
            //5.遍历字典,获取控制器对应的信息(字符串,标题,图片,选中图片)
            guard let vcName = dict["vcName"] else {
                continue
            }
            
            guard let title = dict["title"] else {
                continue
            }
            
            guard let imageName = dict["imageName"] else {
                continue
            }
            
            guard let selectedImageName = dict["selectedImageName"] else {
                continue
            }
            
            addChildViewController(vcName, title: title, imageName: imageName, selectedImageName: selectedImageName)
            
        }
    }
    
        //Swift支持方法的重载
    //方法的重载: 方法名称相同,但是参数不同. --> 1.参数类型不同 2.参数的个数不同
    //private在当前文件中可以访问,但是其它文件不能访问
    private func addChildViewController(_ childVCName: String, title: String, imageName: String, selectedImageName: String) {
        
        //获取命名空间
        guard let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            //没有获取到命名空间
            return
        }
        
        //根据字符串获取对应的class
        guard let childVCClass = NSClassFromString(nameSpace + "." + childVCName) else {
            //获取不到Class
            return
        }
        
        //将对应的AnyClass转成控制器的类型
        guard let childVCType = childVCClass as? UIViewController.Type else {
            //没有获取到对应的控制器类型
            return
        }
        
        //创建对应的控制器对象
        let childVC = childVCType.init()
        
        //设置子控制器属性
        childVC.title = title
        childVC.tabBarItem.image = UIImage(named: imageName)
        childVC.tabBarItem.selectedImage = UIImage(named: selectedImageName)
        
        //包装导航栏控制器
        let childNav = UINavigationController(rootViewController: childVC)
        addChildViewController(childNav)
    }
}


