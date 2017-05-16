//
//  AppDelegate.swift
//  DBWeibo
//
//  Created by zenghz on 2017/2/15.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var defaultViewController: UIViewController? {
        
        let isLogin = WBUserAccountViewModel.shareInstance.isLogin
        return isLogin ? WBWelcomeViewController() : UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //设置全局颜色
        UITabBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.orange
        
        //创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

/// 全局函数
///
/// - Parameters:
///   - message: 要打印的内容
func HZLog<T>( _ message: T, file: String = #file, funcName: String = #function, line: Int = #line) {
    
    //需要在Build setting -> OTHER_SWIFT_FLAGS 添加标记
    //:configuration = Debug
    //OTHER_SWIFT_FLAGS[arch=*] = -D DEBUG
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        
        print("\(fileName): [\(funcName)] (\(line)) - \(message)")
        
    #endif
}
